Sub Main()

    initTheme()
    showCategories() 

End Sub


'*************************************************************
'** Set the configurable theme attributes for the application
'** 
'** Configure the custom overhang and Logo attributes
'** Theme attributes affect the branding of the appication
'** and are artwork, colors and offsets specific to the app
'*************************************************************

Sub initTheme()

    app = CreateObject("roAppManager")
    theme = CreateObject("roAssociativeArray")

    theme.OverhangOffsetSD_X = "0"
    theme.OverhangOffsetSD_Y = "25"
    theme.OverhangSliceSD = "pkg:/images/overhang_background_sd_720x110.jpg"
    theme.OverhangLogoSD  = "pkg:/images/overhang_logo_sd_160x40.jpg"
    theme.OverhangOffsetHD_X = "0"
    theme.OverhangOffsetHD_Y = "25"
    theme.OverhangSliceHD = "pkg:/images/overhang_background_hd_1281x165.jpg"
    theme.OverhangLogoHD  = ""
    theme.BreadcrumbTextRight = "#E8BB4B"
    theme.BackgroundColor = "#FFFFFF"

    app.SetTheme(theme)

End Sub

Function showCategories()

    categories = [{ Title: "White House Live",
                    SDPosterUrl: "pkg:/images/category_poster_304x237_livestream.jpg",
                    HDPosterUrl: "pkg:/images/category_poster_304x237_livestream.jpg"
                  },
                  { Title: "Your Weekly Address",
                    SDPosterUrl: "pkg:/images/category_poster_304x237_yourweeklyaddress.jpg",
                    HDPosterUrl: "pkg:/images/category_poster_304x237_yourweeklyaddress.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/weekly-addresses/rss.xml"
                  },
                  { Title: "White House Press Briefings",
                    SDPosterUrl: "pkg:/images/category_poster_304x237_pressbriefings.jpg",
                    HDPosterUrl: "pkg:/images/category_poster_304x237_pressbriefings.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/press-briefings/rss.xml"
                  },
                  { Title: "Speeches and Events",
                    SDPosterUrl: "pkg:/images/category_poster_304x237_speechesandevents.jpg",
                    HDPosterUrl: "pkg:/images/category_poster_304x237_speechesandevents.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/speeches/rss.xml"
                  },
                  { Title: "White House Features",
                    HDPosterUrl: "pkg:/images/category_poster_304x237_features.jpg",
                    SDPosterUrl: "pkg:/images/category_poster_304x237_features.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/white-house-features/rss.xml"
                  },
                  { Title: "West Wing Week",
                    SDPosterUrl: "pkg:/images/category_poster_304x237_westwingweek.jpg",
                    HDPosterUrl: "pkg:/images/category_poster_304x237_westwingweek.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/west-wing-week/rss.xml"
                  },
                  { Title: "The First Lady",
                    SDPosterUrl: "pkg:/images/category_poster_304x237_firstlady.jpg",
                    HDPosterUrl: "pkg:/images/category_poster_304x237_firstlady.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/the-first-lady/rss.xml"
                  },
                  { Title: "Music and Arts in the White House",
                    SDPosterUrl: "pkg:/images/category_poster_304x237_musicandarts.jpg",
                    HDPosterUrl: "pkg:/images/category_poster_304x237_musicandarts.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/music-and-the-arts-at-the-white-house/rss.xml"
                  },
                  { Title: "Open For Questions",
                    SDPosterUrl: "pkg:/images/category_poster_304x237_openquestions.jpg",
                    HDPosterUrl: "pkg:/images/category_poster_304x237_openquestions.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/open-for-questions/rss.xml"
                 }]

    screen = CreateObject("roPosterScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.SetListStyle("arced-landscape")
    screen.SetAdUrl("http://assets.sunlightfoundation.com.s3.amazonaws.com/roku/banner_ad_sd_540x60.jpg", "http://assets.sunlightfoundation.com.s3.amazonaws.com/roku/sunlight2_728x90_roku.jpg")
    screen.SetAdDisplayMode("scale-to-fit")   
    screen.SetContentList(categories)
    screen.SetFocusedListItem(0)
    screen.Show() 

    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roPosterScreenEvent" then 
            if msg.isListItemSelected() then
                if msg.GetIndex() = 0 then
                    ShowLiveVideo(categories[0])
                else
                    ShowVideosForCategory(categories[msg.GetIndex()])
                end if 
            else if msg.isScreenClosed() then
                return -1
            end if
        end if 
    end while

End Function

Function showNoLiveMessage()
    message = CreateObject("roMessageDialog")
    message.SetText("We're sorry but there are no live events happening right now")
    message.AddButton(1, "OK")
    message.SetMessagePort(CreateObject("roMessagePort"))    
    message.Show()
    while true
        dlmsg = wait(0, message.GetMessagePort())
        if dlmsg.isButtonPressed()
            return -1
        endif
    end while
End Function

Function ShowLiveVideo(video)
    'need to check if any upcoming or available
'    http = NewHttp("10.13.33.209")
    waitobj = ShowPleaseWait("Checking for live videos", "")
    videos = CreateObject("roArray", 10, true)
    url = "http://api.realtimecongress.org/api/v1/videos.xml?per_page=7&apikey=" + GetKey() + "&status!=archived&sort=status&chamber=whitehouse"
    print url
    http = NewHttp(url)
    response = http.GetToStringWithRetry()
    xml = CreateObject("roXMLElement")
    if not xml.Parse(response) then
        'show error dialog
        print "couldn't parse response"
        print url
        waitobj = "forget it" 
        ShowNoLiveMessage()
        return -1
    else:
        if xml.count.GetText().ToInt() > 0 then
            for each vid in xml.videos.video
                status = vid.GetNamedElements("status").GetText()
                if status = "live" then
                    o = {   StreamUrls : [vid.GetNamedElements("clip-urls")[0].hls.GetText()],
                            Live : true,
                            StreamBitrates : [0],
                            StreamQualities : "HD",
                            StreamFormat: "hls",
                            ContentType : "episode",
                            Title : vid.GetNamedElements("title").GetText(),
                            Description: vid.GetNamedElements("pubdate").GetText(),
                            ShortDescriptionLine1: vid.GetNamedElements("title").GetText(),
                            SDPosterUrl: "pkg:/images/video_clip_poster_sd_185x94.jpg",
                            HDPosterUrl: "pkg:/images/video_clip_poster_hd250x141.jpg",
                            Status: status
                        }
                else
                    timestamp = vid.GetNamedElements("start-time").GetText()
                    date = Left(timestamp, 10)
                    time = Mid(timestamp, 12, 8)
                    
                    rodate = CreateObject("roDateTime")
                    rodate.fromISO8601String(date + " " + time)
                    hours = rodate.getHours()
                    minutes = rodate.getMinutes()
                    print hours
                    p = "AM"
                    if hours > 12 then
                        hours = hours - 12
                        p = "PM"
                    else if hours = 12 then
                        p = "PM"
                    end if
                    start_time = hours.toStr() + ":" + minutes.toStr() + " " + p
                    rodate.toLocalTime()
                    o = {
                        ContentType: "episode",
                        Title: vid.GetNamedElements("title").GetText(),
                        ShortDescriptionLine1: vid.GetNamedElements("title").GetText(),
                        ShortDescriptionLine2: "Starting at " + start_time,
                        Status: status,
                        SDPosterUrl: "pkg:/images/video_clip_poster_sd_185x94_muted.jpg",
                        HDPosterUrl: "pkg:/images/video_clip_poster_hd250x141_muted.jpg",
                        }
                end if
                videos.push(o)
            next 
            screen = CreateObject("roPosterScreen")
            port = CreateObject("roMessagePort")
            screen.SetMessagePort(port)
            screen.SetListStyle("flat-episodic-16x9")
            screen.SetAdUrl("http://assets.sunlightfoundation.com.s3.amazonaws.com/roku/banner_ad_sd_540x60.jpg", "http://assets.sunlightfoundation.com.s3.amazonaws.com/roku/sunlight2_728x90_roku.jpg")
            screen.SetAdDisplayMode("scale-to-fit")   
            screen.SetContentList(videos)
            screen.SetFocusedListItem(0)
            waitobj = "forget it" 
            screen.Show()
            while true
            msg = wait(0, screen.GetMessagePort())
                if type(msg) = "roPosterScreenEvent" then
                    if msg.isListItemSelected() then
                        if videos[msg.GetIndex()].Status = "live" then 
                            ShowVideoScreen(videos[msg.GetIndex()])
                        end if
                    else if msg.isScreenClosed() then
                        return -1
                    end if
                end if 
            end while
        else
            waitobj = "forget it"
            print xml.count.GetText()
            print "no count obj or count is 0 " 
            ShowNoLiveMessage()
            return -1
        endif
    endif
End Function

Function ShowVideosForCategory(category)
    waitobj = ShowPleaseWait("Retrieving videos in this category", "")
    videos = GetVideosForCategory(category)
    video_count = str(videos.Count())
    screen = CreateObject("roPosterScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.SetListStyle("flat-episodic-16x9")
    screen.SetAdUrl("http://assets.sunlightfoundation.com.s3.amazonaws.com/roku/banner_ad_sd_540x60.jpg", "http://assets.sunlightfoundation.com.s3.amazonaws.com/roku/sunlight2_728x90_roku.jpg")
    screen.SetAdDisplayMode("scale-to-fit")   
    screen.SetContentList(videos)
    screen.SetFocusedListItem(0)
    screen.SetBreadcrumbText("", "1 of " + video_count)
    waitobj = "forget it"
    screen.Show() 
        
    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roPosterScreenEvent" then
            if msg.isListItemFocused() then
                screen.SetBreadcrumbText("", str(msg.GetIndex() + 1) + " of " + video_count)
                screen.show()
            end if
            if msg.isListItemSelected() then
                ShowVideoScreen(videos[msg.GetIndex()])
            else if msg.isScreenClosed() then
                return -1
            end if
       end if 
    end while
End Function

Function GetVideosForCategory(category)

    http = NewHttp(category.rssUrl)
    response = http.GetToStringWithRetry()
    videos = CreateObject("roArray", 30, true)

    xml = CreateObject("roXMLElement")
    if not xml.Parse(response) then
        print "can't parse feed"
        return -1
    end if
    for each item in xml.channel.item
        o = GetVideo(item)
        if type(o) = type({}) then
            videos.Push(o)
        end if
    next

    return videos

End Function

Function GetVideo(item)
    video_url = item.enclosure@url
    ext = right(video_url, 3)
    if ext = "mp4" or ext = "m4v" then
        o = {}
        o.Title = item.title.GetText()
        o.Description = item.description.GetText()
        o.ShortDescriptionLine1 = o.Title
        o.StreamUrls = [video_url]
        o.StreamBitrates = [0]
        o.StreamFormat = "mp4"
        o.StreamQualities = ["HD"]
        o.SDPosterUrl = "pkg:/images/video_clip_poster_sd_185x94.jpg"
        o.HDPosterUrl = "pkg:/images/video_clip_poster_hd250x141.jpg"
        o.ContentType = "episode"

        return o
    end if
    return -1

End Function
