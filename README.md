About This Package
==================

Here are some Xcode text macros I use for writing Objective-C code.
They speed up my coding a lot, especially the macros for methods.

Let me know if you wrote useful macros that you would like to add
to this collection. The best way is by forking this project on github,
adding your macros, and sending me a pull request.

There is also a cheat sheet generator that lists the macros on an HTML
page with their completion prefixes and your keybord shortcuts.
[Here’s an example](http://www.entropy.ch/software/macosx/xcode-macro-cheat-sheet.html)
with my particular keyboard shortcuts. You’re more than welcome to
spice up that HTML in the XSLT :-)


About Xcode’s Text Macros in General
====================================

My guess is that text macros are not well known to many Xcode users. They aren’t
easy to find where they are, deep down in submenus of the Edit menu, with no default
keyboard shortcuts. I know I didn’t use them a lot, I used
[Objective Development](http://www.obdev.at)’s
[Completion Dictionary](http://www.obdev.at/products/completion-dictionary/index.html)
instead. Personally, I would give the macros their own toplevel menu bar item in Xcode,
with a nice space-saving icon like the one
[BBEdit](http://www.barebones.com/products/bbedit/) uses for its clippings.

Xcode’s macro system is very powerful. The first step to harnessing that power
for your daily coding is to start using the macros that are already there:

* Assigning keyboard shortcuts to the most often used ones is *highly*
  recommended, especially to get one of the coolest macro features,
  cycle lists. Cycle lists link together related macros and let you
  quickly flip through them by repeatedly pressing the shortcut. While
  Xcode switches from variant to variant, it preserves your wrapped
  selected text (see next item) and replaces just the macro code around
  it.
  Cycle lists are useful for variants of similar constructs such as `if ()`
  statements or method definitions. Until recently I didn’t know about
  cycle lists. The cheat sheet shows you which macros are grouped together
  in such a list.
* Another great feature that’s easier to use with keyboard shortcuts is
  the ability of some macros to wrap selected text. Again this is useful
  for block statements such as `if ()`, especially in combination with the previous
  feature. Select a bunch of lines, hit the shortcut to wrap them in an
  `if ()` block, hit the shortcut again to switch to an `if / else` block.
  Taken together, this results in a killer feature.
* I recommend picking a simple and consistent keyboard shortcut convention
  across all macros. I use just the Ctrl key with letters. Obviously
  this only works because I don’t use the emacs text editing bindings,
  except maybe Ctrl-T once in a while. My recommendations are listed below
  in the macro list and in the cheat sheet sample. You could also use the
  number keys with Cmd-Ctrl. Whatever you pick, if you make it something
  simple and unified, you’ll have an easier time remembering the shortcuts,
  and only if you remember and use them a lot will you get the full time-saving
  benefit.
* You might use some macros once in a while, but not often enough to justify
  giving them their own shortcut. In those cases it’s a good idea to
  still memorize their completion shortcut, which is the next best thing.
  To insert the macro, type the completion shortcut and hit the tab key.
* I like to see the completion suggestions right away in a popup list.
  I set the “Automatically Suggest” time in the Xcode preferences to “Immediate”
  and enabled the list with this setting: `defaults write com.apple.Xcode XCCodeSenseAutoSuggestionStyle List`.

The next step is to start writing (and hopefully sharing) your own macros:

* Xcode’s macro language is fairly complicated, and as far as I know not
  well-documented, but it is also very powerful because it uses an inheritance
  system and flexible token replacement features. It’s worth to learn it,
  and you can learn a lot by looking at the built-in `C.xctxtmacro` file.
  The built-in macro files are in the Xcode application bundle in
  `Contents/PlugIns/TextMacros.xctxtmacro/Contents/Resources/`.
* The Xcode user defaults also influence the macros, specifically the whitespace.
  These defaults are documented [here](http://developer.apple.com/mac/library/documentation/DeveloperTools/Reference/XcodeUserDefaultRef/100-Xcode_User_Defaults/UserDefaultRef.html#//apple_ref/doc/uid/TP40005535-CH3-SW40).
* Completion prefixes are more useful when you limit the macros to the
  source code contexts in which they make sense. You do that by specifying
  appropriate context include and exclude lists for each macro. To find out
  what contexts are active at a particular source code location, I use
  a one-line shell script with the command `echo $XCSourceContext`
  that I added as an Xcode user script. I place the cursor in the location
  I’m interested in and run the script, which inserts the list of context
  identifiers.


About the Macros
================

With both the built-in macros and the ones in this collection here, play
around a bit, with something selected, nothing selected etc. to see what
gets wrapped, where the cursor ends up, what placeholders get inserted.
If you spend a lot of time in Xcode, you’ll really want to get familiar
with text macros.

Installation Xcode 4
--------------------

    cd *your-git-repository*
    ln -s "$PWD/MyMacros-CodeSnippets" ~/Library/Developer/Xcode/UserData/CodeSnippets

Sadly, you currently can’t collect links/aliases to your code snippets within the `~/Library/Developer/Xcode/UserData/CodeSnippets` directory. Xcode 4 seems to expect a flat directory structure.

Installation
------------

Put the .xctxtmacro file into your

    "$HOME/Library/Application Support/Developer/Shared/Xcode/Specifications/"

directory. Then restart Xcode so it picks them up. *Definitely* assign keyboard
shortcuts :-)

Ideally, you would `git clone` this project directly from GitHub
to some location on your system and put a symbolic link to the macro file into
the directory given above. 

As the directory is not there by default, the easiest way to create it is

	`mkdir -p "$HOME/Library/Application Support/Developer/Shared/Xcode/Specifications/"`

which will recursively create all necessary directories down to that level. Then add a 
symbolic link to the .xctxtmacro file:

	`ln -s *your-git-repository*/MyMacros.xctxtmacro "$HOME/Library/Application Support/Developer/Shared/Xcode/Specifications/"`

That way, you can always update to the newest version
of the macro collection with a simple `git pull`. If you start your own collection
of macros, put them into a separate file in the same directory.

Here’s a quick run-down of some of the macros:


Strings
-------

### Objective-C String Literal

Inserts `@""`. If something is selected, it puts that between the quotes.
Without selection, moves the cursor between the quotes.

Recommended shortcut: ⌃\

### NSString With Format

Inserts `[NSString stringWithFormat:...]` with a format string and arguments placeholders.

Recommended shortcut: ⌃F

Containers
-------

### NSMutableArray

Inserts `NSMutableArray *`.

Recommended shortcut: use completion prefix `nsma`

### NSMutableArray array

Inserts `[NSMutableArray array]`.

Recommended shortcut: use completion prefix `nsmaa`

### NSString With Format

Inserts `[NSString stringWithFormat:...]` with a format string and arguments placeholders.

Recommended shortcut: ⌃F


NSLog()
-------

Inserts `NSLog()` calls with zero and one arguments. The two are linked
in a cycle list.

Recommended shortcut: ⌃L


Control Statements
------------------

### Single-Statement if ()

Inserts an `if ()` statement without the braces. It’s linked to several
other `if ()` statement variants in a cycle list.

Recommended shortcut: ⌃I

Markers
-------

### TODO Marker

Inserts a `// TODO:` comment, which will show up in Xcode’s function popup.

Recommended shortcut: Use completion prefix `todo`;

### FIXME Marker

Inserts a `// FIXME:` comment, which will show up in Xcode’s function popup.

Recommended shortcut: Use completion prefix `fix`;

### TODO Marker

Inserts a `// !!!:` comment, which will show up in Xcode’s function popup.

Recommended shortcut: Use completion prefix `fix2`;

Methods
-------

### Declarations and Definitions

Several variants of method declarations and definitions with different return
value and parameter combinations. If you assign a keyboard shortcut, it should
be assigned to the “Return Value no Parameters” variants of declaration or definition
because those define the cycle list.

The completion prefixes are identical for declaration and definition of each variant,
but the macros are context-sensitive. If you use a completion prefix in an implementation
context, a definition will be inserted, and if you use the same prefix in an interface
context, a declaration will be inserted.

Recommended shortcut for definition: ⌃M

Recommended shortcut for declaration: ⌃H

### Method Parameter

Inserts an `xxxx:(yyy)zzz` sequence to add a parameter to a method
definition/declaration. Ideal for combination with the method
blocks in the previous item.

Recommended shortcut: Suggest to use the completion prefix.

### Bracket Expression

Inserts a bracket expression. The built-in bracket expression has
a trailing space that I don’t like.

Recommended shortcut: ⌃[

Properties
----------

### Declarations

Inserts `@property` declarations. If you assign a keyboard shortcut, it should
be assigned to the “retain” variant. Cycles through three variants with
the `retain`, `assign` and `copy` attributes. The selection ends
up in the type and name part. Tip: copy/paste the property’s
instance variable declaration and paste it where you want the
declaration, select it and invoke the shortcut.

Recommended shortcut: ⌃P

### Synthesize

Inserts `@synthesize` instructions. Cycles through two variants,
the second of which uses the `property = ivar` form to assign the
property to an ivar with a different name.

Recommended shortcut: ⌃S

### Release and nil ivar

Inserts two lines to release and nil an ivar in a dealloc method.
The selection is used as ivar name.

Recommended shortcut: Use the completion prefix `rel`.

Grand Central Dispatch
----------------------

### dispatch_async() to Global Concurrent Queue

Inserts a `dispatch_async()` statement with a block literal targeting
the global concurrent queue. A selection or the cursor ends up in the block.
Cycles through the other dispatch_* variants below.

Recommended shortcut: ⌃D or use the completion prefix, `dia`.

### dispatch_async() to Main Queue

Inserts a `dispatch_async()` statement with a block literal targeting
the main queue. A selection or the cursor ends up in the block.

Recommended shortcut: Use completion prefix `diam`.

### dispatch_sync() to Main Queue

Inserts a `dispatch_sync()` statement with a block literal targeting
the main queue. A selection or the cursor ends up in the block.

Recommended shortcut: Use completion prefix `dis`.

### Block Literal

Inserts a block literal. Cycles through variants with an empty argument
list and an argument list for an NSComparator block. A selection or the
cursor ends up between the braces.

Recommended shortcut: Use completion prefix ⌃]


About the Cheat Sheet Generator
===============================

The cheat sheet generator reads the macros in Apple’s C and
Objective-C files built in to Xcode. By default it doesn’t
read the shortcuts for C++ or the other languages supported
by Xcode, because I don’t use those and don’t want them cluttering
up the list. If you want them you can enable them in the generator’s
`read_macro_definitions()` method.

It doesn’t skip any of the `.xctxtmacro` files in your personal
directory, as it’s likely that you want all of those...


Related Projects
================

Here are some related projects:

* [xobjc - Shortcuts for lazy Objective-C developers](http://github.com/holtwick/xobjc)
