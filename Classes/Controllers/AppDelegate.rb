# AppDelegate.rb
# FuzzyWindow
#
# Created by Geoffrey Grosenbach on 3/20/10.
# Copyright 2010 Topfunky Corporation. All rights reserved.

class AppDelegate

  attr_accessor :fuzzyWindowController, :preferencesWindowController, :welcomeWindowController, :releaseNotesWindowController, :statusMenu, :aboutWindowController

  def self.registrationDefaults
    {
      "editorApplicationName" => "TextMate",
      "maximumDocumentCount"  => 1000,
    }
  end

  def applicationWillFinishLaunching(aNotification)
    NSUserDefaults.standardUserDefaults.registerDefaults(AppDelegate.registrationDefaults)
  end

  def applicationDidFinishLaunching(aNotification)
    createStatusBarMenu

    unless NSUserDefaults.standardUserDefaults.boolForKey("hasBeenRunAtLeastOnce")
      showWelcome(self)
    end
  end

  def createStatusBarMenu
    statusItem =
      NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength)
    statusItem.setMenu(statusMenu)
    statusItem.setHighlightMode(true)
    statusItem.setToolTip("PeepOpen")
    statusItem.setImage(NSImage.imageNamed("statusItemIcon.png"))
  end

  ##
  # Do something with the dropped file.

  def application(sender, openFile:path)
    fuzzyWindowController.show(self)
    fuzzyWindowController.loadFilesFromProjectRoot(path)
  end

  def showPreferences(sender)
    # TODO: If visible
    if fuzzyWindowController.respondsToSelector(:close)
      fuzzyWindowController.close
    end
    self.preferencesWindowController =
      windowControllerForNib("PreferencesWindow")
    preferencesWindowController.show(self)
  end

  def showWelcome(sender)
    self.welcomeWindowController =
      windowControllerForNib("WelcomeWindow")
    welcomeWindowController.show(self)
  end

  def showReleaseNotesWindow(sender)
    self.releaseNotesWindowController =
      windowControllerForNib("ReleaseNotesWindow")
    releaseNotesWindowController.show(self)
  end

  def showAbout(sender)
    if (!aboutWindowController)
      self.aboutWindowController =
        windowControllerForNib("AboutWindow")
    end      
    aboutWindowController.show(self)
  end
  
  def refreshFileList(sender)
    # TODO: If fuzzyWindowController, flush only the records from current project, and reload.
    FuzzyRecord.flushCache()
  end
    

  private

  # Given +nibName+, allocate and initialize the appropriate window
  # controller for the NIB.
  def windowControllerForNib nibName
    klass = Object.const_get "#{nibName}Controller"
    klass.alloc.initWithWindowNibName(nibName)
  end

  def fuzzyWindowController
    @fuzzyWindowController ||= windowControllerForNib("FuzzyWindow")
  end

end

