require 'osx/cocoa'
include OSX

class App < NSObject

  def applicationDidFinishLaunching(note)
    statusbar = NSStatusBar.systemStatusBar
    status_item = statusbar.statusItemWithLength(NSVariableStatusItemLength)

    image = NSImage.alloc.initWithContentsOfFile 'stretch.tiff'
    raise "Icon stretch.tiff is missing." unless image

    status_item.setImage image
    SpeechController.alloc.init.add_menu_to status_item
    @spoken_count = 0X
  end

  def applicationShouldTerminate(app)
    puts "spoken count: #{@spoken_count}"
    true if @spoken_count > 2
  end

  def app_did_speak
    @spoken_count = @spoken_count + 1
  end
end

class SpeechController < NSObject

  def init
    super_init
    @synthesizer = NSSpeechSynthesizer.alloc.init

    self
  end

  def add_menu_to(container)
    menu = NSMenu.alloc.init
    container.setMenu menu
    menu_item = menu.addItemWithTitle_action_keyEquivalent "Speak", "speak:", ''
    menu_item.setTarget self
    menu_item = menu.addItemWithTitle_action_keyEquivalent "Quit", "terminate:", 'q'
    menu_item.setKeyEquivalentModifierMask(NSCommandKeyMask)
    menu_item.setTarget(NSApp)
  end

  def speak(sender)
    @synthesizer.startSpeakingString "I have nothing to say."
    NSApp.delegate.app_did_speak
    sender.setTitle "Speak Again"
  end
  
end


NSApplication.sharedApplication
NSApp.setDelegate(App.alloc.init)
NSApp.run
