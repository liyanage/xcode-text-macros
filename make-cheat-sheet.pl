#!/usr/bin/perl
#
# Format Xcode text macro list
#

use strict;
use warnings;

use XML::LibXML;

exit Tool->new(@ARGV)->run();


package Tool;

sub new {
	my $self = shift;
	my %args = @_;
	
	my $class = ref($self) || $self;
	$self = bless {args => \%args}, $class;
	$self->init();
	return $self;
}

sub init {
	my $self = shift;
	$self->{keyboard_shortcuts} = {};
	$self->{macro_elements} = {};
}

sub run {
	my $self = shift;

	$self->read_keyboard_shortcuts();
 	$self->read_macro_definitions();
 	$self->generate_output();

	return 0;
}

sub read_keyboard_shortcuts {
	my $self = shift;
	
	my $xcode_prefs = $self->read_plist("$ENV{HOME}/Library/Preferences/com.apple.Xcode.plist");
	my $active_key_binding = $xcode_prefs->findvalue('//string[preceding-sibling::key[1][. = "PBXActiveKeyBindings"]]');
	my $path = "$ENV{HOME}/Library/Application Support/Xcode/Key Bindings/$active_key_binding.pbxkeys";
	return unless (-e $path); # no personalized key bindings available

	my $bindings = $self->read_plist($path);
	my @text_macro_nodes = $bindings->findnodes('//string[starts-with(., "textMacro_")]');
	my @pairs = map {$_->findvalue('.') => $_->findvalue('preceding-sibling::key[1]')} @text_macro_nodes;

	my %modifier_map = (
		'^' => "\x{2303}",
		'@' => "\x{2318}",
		'~' => "\x{2325}",
		'$' => "\x{21e7}",
	);

	while (my $macro_identifier = shift @pairs) {
		my $shortcut = shift @pairs;
		$macro_identifier = join('.', $macro_identifier =~ /_([^_]+)/g);
		$shortcut =~ s/(.)/$modifier_map{$1} || $1/eg;
		$shortcut =~ s/(\w)/uc($1)/eg;
		$shortcut =~ s/\\\\/\\/g;
		$self->{keyboard_shortcuts}->{$macro_identifier} = $shortcut;
	}
}


sub read_macro_definitions {
	my $self = shift;
	
	my @macrofiles = (
		'/Developer/Applications/Xcode.app/Contents/PlugIns/TextMacros.xctxtmacro/Contents/Resources/C.xctxtmacro',
		'/Developer/Applications/Xcode.app/Contents/PlugIns/TextMacros.xctxtmacro/Contents/Resources/ObjectiveC.xctxtmacro',
		glob("'$ENV{HOME}/Library/Application\ Support/Developer/Shared/Xcode/Specifications/'*.xctxtmacro"),
	);
	
	foreach my $macrofile (@macrofiles) {
		$self->read_macrofile($macrofile);
	}
	
	my $doc = XML::LibXML::Document->new();
	my $root = $doc->createElement('plist');
	$doc->setDocumentElement($root);
	my $array = $doc->createElement('array');
	$root->appendChild($array);	
	foreach my $identifier (sort keys %{$self->{macro_elements}}) {
		my $element = $self->{macro_elements}->{$identifier};
		$array->appendChild($element);
	}
	$self->{doc} = $doc;
}


sub read_macrofile {
	my $self = shift;
	my ($path) = @_;
	my $doc = $self->read_plist($path);

	foreach my $element ($doc->findnodes('//dict[key = "Identifier"]')) {
		$self->add_macro($element);		
	}
}


sub add_macro {
	my $self = shift;
	my ($element) = @_;

# 	my %formatting_options = (
# 		PreExpressionsSpacing => " ",
# 		PostCommaSpacing => " ",
# 		PreMethodTypeSpacing => " ",
# 		PreMethodDeclSpacing => " ",
# 		BlockSeparator => " ",
# 		CaseStatementSpacing => "\t",
# 		PostBlockSeparator => "\t",
# 		FunctionBlockSeparator => "\t",
# 	);
# 
# 	my ($textnode) = $element->findnodes('string[preceding-sibling::key[1][. = "TextString"]]');
# 	if ($textnode) {
# 		my $text = $textnode->textContent();
# 		$text =~ s/\$\((\w+)\)/$formatting_options{$1} || ''/eg;
# 		$textnode->removeChildNodes();
# 		$textnode->appendText($text);
# 	}
	
	my $identifier = $element->findvalue('string[preceding-sibling::key[1][. = "Identifier"]]');
	my $name_lc = lc($element->findvalue('string[preceding-sibling::key[1][. = "Name"]]'));
	$element->setAttribute(identifier => $identifier);
	$element->setAttribute(name_lc => $name_lc);
	$self->assign_shortcut_to_macro($element);
	
	$self->{macro_elements}->{$identifier} = $element;
}


sub assign_shortcut_to_macro {
	my $self = shift;
	my ($element) = @_;

	my $identifier = $element->getAttribute('identifier');
	my $shortcut = $self->{keyboard_shortcuts}->{$identifier};
	return unless $shortcut;

	$element->setAttribute(shortcut => $shortcut);
#	print $element->toString();

}






sub read_plist {
	my $self = shift;
	my ($path) = @_;
	my $plist_xml_string = qx(plutil -convert xml1 -o - "$path");
	die "Unable to read plist at '$path'" unless $plist_xml_string;
	my $parser = XML::LibXML->new();
	$parser->no_network(1);
	$parser->recover_silently(1);
	my $doc = $parser->parse_string($plist_xml_string);
	die "Unable to parse XML converted from '$path'" unless $doc;
	return $doc;
}


sub generate_output {
	my $self = shift;
	my $path = '/tmp/xcode-text-macros.plist';
	my $path_out = 'xcode-macro-cheat-sheet.html';
	$self->{doc}->toFile($path);
	system('xsltproc', '-o', $path_out, 'xctxtmacro2html.xslt', $path);
#	system('qlmanage', '-p', $path_out);
	system('open', $path_out);
}

