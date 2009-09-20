require 'osx/cocoa'
include OSX

class AppDelegate < NSObject
  def applicationDidFinishLaunching(aNote)
    puts "got a notification: #{aNote.name}, #{aNote.object.to_s}"
  end
end

our_object = AppDelegate.alloc.init
NSApplication.sharedApplication
NSApp.setDelegate our_object
NSApp.run
