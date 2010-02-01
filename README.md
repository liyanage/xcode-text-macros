About This Package
==================

Here are some Xcode text macros I use for writing Objective-C code.
They speed up my coding a lot, especially the macros for methods.

Let me know if you wrote useful macros that you would like to add
to this collection. The best way is by forking this project on github,
adding your macros, and sending me a pull request.

There is also a cheat sheet generator that lists the macros on an HTML
page with their completion prefixes and your keybord shortcuts.
Here’s an [example](http://www.entropy.ch/software/macosx/xcode-macro-cheat-sheet.html).
You’re more than welcome to spice up that HTML in the XSLT:-)


About Xcode’s Text Macros in General
====================================

My guess is that they are underutilized by Xcode users. They certainly
aren’t very discoverable where they are in the Edit menu, with no keyboard
shortcuts assigned by default. Personally, I would give them their own toplevel
menu bar item in Xcode, with a nice space-saving icon like the one
[BBEdit](http://www.barebones.com/products/bbedit/)
uses for its clippings.

I know I didn’t use them a lot, I used
[Objective Development](http://www.obdev.at)’s
[Completion Dictionary](http://www.obdev.at/products/completion-dictionary/index.html)
instead.

But Xcode’s macros are very powerful. The first step to harnessing that power
for your daily coding is to start using what’s already there:

* Assigning keyboard shortcuts to the most often used macros is *highly*
  recommended, especially to get one of the coolest text macro features,
  cycle lists. Cycle lists link together related macros and let you
  quickly flip through them by repeatedly pressing the shortcut. This
  is very useful for different variants of `if ()` statements, for example.
  Until recently I didn’t even know about cycle lists. The cheat sheet
  shows you which macros are part of a cycle list.
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

The second step is to start writing (and hopefully sharing) your own macros:

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

Installation
------------

Put the .xctxtmacro file into your

    "$HOME/Library/Application Support/Developer/Shared/Xcode/Specifications/"

directory. Then restart Xcode so it picks them up. *Definitely* assign keyboard
shortcuts :-)

Ideally, you would `git clone` this project directly from GitHub
to some location on your system and put a symbolic link to the macro file into
the directory given above. That way, you can always update to the newest version
of the macro collection with a simple `git pull`. If you start your own collection
of macros, put them into a separate file in the same directory.

Here’s a quick run-down of some of the macros:

Objective-C String Literal
--------------------------

Inserts `@""`. If something is selected, it puts that between the quotes.
Without selection, moves the cursor between the quotes.

Recommended shortcut: ⌃\

NSLog() Calls
-------------

Inserts `NSLog()` calls with zero and one arguments. The two are linked
in a cycle list.

Recommended shortcut: ⌃L

Single-Statement if ()
----------------------

Inserts an `if ()` statement without the braces. It’s linked to several
other `if ()` statement variants in a cycle list.

Recommended shortcut: ⌃I

Method Definitions
------------------

Several variants of methods with different return value and parameter
combinations. They are linked together in a cycle list.

Recommended shortcut: ⌃M

Method Parameter
----------------

Inserts an `xxxx:(yyy)zzz` sequence to add a parameter to a method
definition/declaration. Ideal for combination with the method
blocks in the previous item.

Recommended shortcut: ⌃P

@property Declarations
----------------------

Inserts @property declarations. Cycles through three variants with
the `retain`, `assign` and `copy` attributes. The selection ends
up in the type and name part. Tip: copy/paste the property’s
instance variable declaration and paste it where you want the
declaration, select it and invoke the shortcut.

Recommended shortcut: ⌃R

@property Synthesize
--------------------

Inserts @synthesize instructions. Cycles through two variants,
the second of which uses the `property = ivar` form to assign the
property to an ivar with a different name.

Recommended shortcut: ⌃S

NSString With Format
--------------------

Inserts [NSString stringWithFormat:...].

Recommended shortcut: ⌃F


About the Cheat Sheet Generator
===============================

The cheat sheet generator reads the macros in Apple’s C and
Objective-C files built in to Xcode. By default it doesn’t
read the shortcuts for C++ or the other languages supported
by Xcode, because I don’t use those and don’t want them cluttering
up the list. If you want them you can enable them in the generator’s
`read_macro_definitions()` method.

It reads *all* of the `.xctxtmacro` files in your personal
directory, as it is likely that you care a lot about those...


Related Projects
================

Here are some related projects:

* [xobjc - Shortcuts for lazy Objective-C developers](http://github.com/holtwick/xobjc)
