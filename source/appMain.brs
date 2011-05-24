Sub Main()

    
   
    setDateObjs()

        
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
Sub setDateObjs()
    'testing ground
    m.months = { Jan: "01"
               Feb: "02"
               Mar: "03"
               Apr: "04"
               May: "05"
               Jun: "06"
               Jul: "07"
               Aug: "08"
               Sep: "09"
               Oct: "10"
               Nov: "11"
               Dec: "12"
            }


    m.DST_hash = { start_2011: "2011-03-13 02:00:00"
                 end_2011: "2011-11-06 02:00:00"
                 start_2012: "2012-03-11 02:00:00"
                 end_2012: "2012-11-04 02:00:00"
                 start_2013: "2013-03-10 02:00:00"
                 end_2013: "2013-11-03 02:00:00"
                 start_2014: "2014-03-09 02:00:00"
                 end_2014: "2014-11-02 02:00:00"
                 start_2015: "2015-03-08 02:00:00"
                 end_2015: "2015-11-01 02:00:00"
                }

    m.today = CreateObject("roDateTime")
    m.this_year = m.today.GetYear().toStr()
    
    m.dom = CreateObject("roRegex", " \d{2} ", "i")
    m.month = CreateObject("roRegex", "[A-Z]{1}[a-z]{2} ", "")
    m.time_re = CreateObject("roRegex", "\d{2}:\d{2}:\d{2}", "")
    m.year_re = CreateObject("roRegex", "\d{4}", "")

End Sub
 
Sub initTheme()

    app = CreateObject("roAppManager")
    theme = CreateObject("roAssociativeArray")

    theme.OverhangOffsetSD_X = "0"
    theme.OverhangOffsetSD_Y = "0"
    theme.OverhangSliceSD = "pkg:/images/overhang_background_sd_720x83.jpg"
    theme.OverhangLogoSD  = ""
    theme.OverhangOffsetHD_X = "0"
    theme.OverhangOffsetHD_Y = "0"
    theme.OverhangSliceHD = "pkg:/images/overhang_background_hd_1281x165.jpg"
    theme.OverhangLogoHD  = ""
    theme.BreadcrumbTextRight = "#E8BB4B"
    theme.BackgroundColor = "#FFFFFF"

    app.SetTheme(theme)

End Sub

Function showCategories()

    categories = [
                  { Title: "White House Live",
                    SDPosterUrl: "pkg:/images/category_poster_304x237_livestream.jpg",
                    HDPosterUrl: "pkg:/images/category_poster_304x237_livestream.jpg",
                    rssUrl: "http://www.whitehouse.gov/feed/iphone/live"
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
                'if msg.GetIndex() = 0 then
                 '   ShowLiveVideo(categories[0])
                'else
                    ShowVideosForCategory(categories[msg.GetIndex()])
                'end if 
            else if msg.isScreenClosed() then
                return -1
            end if
        end if 
    end while

End Function

Function showNoLiveMessage()
    message = CreateObject("roMessageDialog")
    message.SetText("We're sorry but there are no videos in this category. Please check back later.")
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
                timestamp = vid.GetNamedElements("start_time").GetText()
                date = Left(timestamp, 10)
                time = Mid(timestamp, 12, 8)
                
                rodate = CreateObject("roDateTime")
                rodate.fromISO8601String(date + " " + time)
                rodate.toLocalTime()
                hours = rodate.getHours()
                minutes = rodate.getMinutes().toStr()
                if Len(minutes) = 1 then
                    minutes = "0" + minutes
                end if 
                p = "AM"
                if hours > 12 then
                    hours = hours - 12
                    p = "PM"
                else if hours = 12 then
                    p = "PM"
                end if
                start_time = Str(hours).Trim() + ":" + minutes.Trim() + " " + p

                if status = "live" then
                    o = {   StreamUrls : [vid.GetNamedElements("clip_urls")[0].hls.GetText()],
                            Live : true,
                            StreamBitrates : [0],
                            StreamQualities : "SD",
                            StreamFormat: "hls",
                            ContentType : "episode",
                            Title : vid.GetNamedElements("title").GetText(),
                            Description: "Started at " + start_time,
                            ShortDescriptionLine1: vid.GetNamedElements("title").GetText(),
                            SDPosterUrl: "pkg:/images/video_clip_poster_sd_185x94.jpg",
                            HDPosterUrl: "pkg:/images/video_clip_poster_hd250x141.jpg",
                            Status: status
                        }
                else
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
    if videos.Count() = 0 then
        ShowNoLiveMessage()
        return -1
    endif
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
    if video_url <> invalid then
        ext = right(video_url, 3)
    else
        return -1
    endif
    o = {}
    
    if ext = "mp4" or ext = "m4v" then
        o.StreamFormat = "mp4"
        o.Description = item.description.GetText()
        o.StreamBitrates = [0]
        o.SDPosterUrl = "pkg:/images/video_clip_poster_sd_185x94.jpg"
        o.HDPosterUrl = "pkg:/images/video_clip_poster_hd250x141.jpg"
    else 
        ext = right(video_url, 4)
        if ext = "m3u8" then
            o.StreamFormat = "hls"
            o.StreamBitrates = [817] ' [0] ' [817]
            o.MinBandwidth = 60 
            m.today = CreateObject("roDateTime")
            ds = item.pubDate.getText()
            day_of_month =  m.dom.Match(ds)[0].Trim()
            month_text = m.month.Match(ds)[0]
            month = m.months[month_text.Trim()]
            time_matches = m.time_re.Match(ds)
            hour = time_matches[0].left(2)
            minutes = time_matches[0].mid(3,2)
            year = m.year_re.Match(ds)[0].Trim()

            dst_start_date = CreateObject("roDateTime")
            dst_start_date.fromISO8601String(m.DST_hash["start_"+m.this_year])
            dst_end_date = CreateObject("roDateTime")
            dst_end_date.fromISO8601String(+m.DST_hash["end_"+m.this_year])
            if m.today.getMonth() >= dst_end_date.getMonth() and m.today.getDayOfMonth() >= dst_end_date.getDayOfMonth then
                offset = -5
            elseif m.today.getMonth() >= dst_start_date.getMonth() and m.today.getDayOfMonth() >= dst_start_date.getDayOfMonth() then
                offset = -4
            else
                offset = -5
            endif

            hour_int = hour.toInt()
            minute_int = minutes.toInt()
            print m.today.getHours().toStr()
            print m.today.getMinutes().toStr()
            print hour_int.toStr()
            print minute_int.toStr()
            if m.today.getHours() > hour_int or (m.today.getHours() = hour_int and m.today.getMinutes() >= minute_int) then
                o.Description = "In Progress"
                o.SDPosterUrl = "pkg:/images/video_clip_poster_sd_185x94.jpg"
                o.HDPosterUrl = "pkg:/images/video_clip_poster_hd250x141.jpg"
    
            else
                hour_int = hour_int + offset
                o.SDPosterUrl = "pkg:/images/video_clip_poster_sd_185x94_muted.jpg"
                o.HDPosterUrl = "pkg:/images/video_clip_poster_hd250x141_muted.jpg"
                if hour_int >= 12 then
                    ampm = "PM"
                    if hour_int > 12 then
                        hour_text = (hour_int - 12).toStr() + ":" + minutes + " " + ampm + " EST"
                    else
                        hour_text = hour_int.toStr() + ":" + minutes + " " + ampm + " EST"
                    endif
                else
                    ampm = "AM"
                    hour_text = hour_int.toStr() + ":" + minutes + " " + ampm + " EST"
                endif 
                if m.today.getDayOfMonth() < day_of_month.toInt() then
                    if m.today.getDayOfMonth() + 1 = day_of_month.toInt() then
                        o.Description = "Starts tomorrow at " + hour_text
                    else
                        o.Description = "Starts " + month_text + " " + day_of_month + " at " + hour_text
                    endif
                else
                    o.Description ="Starting at " + hour_text
                endif
            endif
        else
            return -1
        endif
    endif  
    o.Title = item.title.GetText()
    o.ShortDescriptionLine1 = o.Title
    o.StreamUrls = [video_url]
    o.StreamQualities = ["SD"]
    o.ContentType = "episode"

    return o

End Function
