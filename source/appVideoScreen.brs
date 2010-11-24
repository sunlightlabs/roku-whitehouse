'**********************************************************
'**  Video Player Example Application - Video Playback 
'**  November 2009
'**  Copyright (c) 2009 Roku Inc. All Rights Reserved.
'**********************************************************

'***********************************************************
'** Create and show the video screen.  The video screen is
'** a special full screen video playback component.  It 
'** handles most of the keypresses automatically and our
'** job is primarily to make sure it has the correct data 
'** at startup. We will receive event back on progress and
'** error conditions so it's important to monitor these to
'** understand what's going on, especially in the case of errors
'***********************************************************  

Function showVideoFailureMessage()
    message = CreateObject("roMessageDialog")
    message.SetText("We're sorry, the video you requested could not be loaded. We have recorded this event and will report it to the Clerk of the U.S. House of Representatives, the provider of this content.")
    message.AddButton(1, "OK")
    message.SetMessagePort(CreateObject("roMessagePort"))    
    message.Show()
    while true
        dlmsg = wait(0, message.GetMessagePort())
        print type(dlmsg)
        if dlmsg.isButtonPressed()
            return -1 
        endif
    end while
    
End Function

Function showVideoScreen(episode As Object)

    if type(episode) <> "roAssociativeArray" then
        print "invalid data passed to showVideoScreen"
        return -1
    endif

    port = CreateObject("roMessagePort")
    screen = CreateObject("roVideoScreen")
    screen.SetMessagePort(port)
    print "printing episode"
    print episode
    screen.Show()
    screen.SetPositionNotificationPeriod(30)
    screen.SetContent(episode)
    screen.Show()
    'Uncomment his line to dump the contents of the episode to be played
    'PrintAA(episode)

    while true
        msg = wait(0, port)
        if type(msg) = "roVideoScreenEvent" then
            print "showHomeScreen | msg = "; msg.getMessage() " | index = "; msg.GetIndex()
            if msg.isScreenClosed()
                print "Screen closed"
                exit while
            elseif msg.isRequestFailed()
                print "Video request failure: "; msg.GetIndex(); " " msg.GetData() 
                'showVideoFailureMessage()
                return -1
            elseif msg.isStatusMessage()
                print "Video status: "; msg.GetIndex(); " " msg.GetData() 
            elseif msg.isButtonPressed()
                print "Button pressed: "; msg.GetIndex(); " " msg.GetData()
            elseif msg.isPlaybackPosition() then
                nowpos = msg.GetIndex()
                'RegWrite(episode.ContentId, nowpos.toStr())
                print "now position"
                print nowpos
                
            else
                print "Unexpected event type: "; msg.GetType()
            end if
        else
            print "Unexpected message class: "; type(msg)
        end if
    end while
End Function


