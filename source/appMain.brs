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
    theme.OverhangLogoSD  = "pkg:/images/overhang_logo_sd_160x40.png"
    theme.OverhangOffsetHD_X = "0"
    theme.OverhangOffsetHD_Y = "25"
    theme.OverhangSliceHD = "pkg:/images/overhang_background_hd_1281x165.png"
    theme.OverhangLogoHD  = ""
    theme.BreadcrumbTextRight = "#E8BB4B"
    theme.BackgroundColor = "#FFFFFF"

    app.SetTheme(theme)

End Sub

Function showCategories()

    categories = [{ Title: "Your Weekly Address",
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
                ShowVideosForCategory(categories[msg.GetIndex()])
            else if msg.isScreenClosed() then
                return -1
            end if
        end if 
    end while

End Function

Function ShowVideosForCategory(category)
    waitobj = ShowPleaseWait("Retrieving videos in this category", "")
    videos = GetVideosForCategory(category)
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
