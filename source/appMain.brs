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
                    SDPosterUrl: "category_poster_304x237_yourweeklyaddress.jpg",
                    HDPosterUrl: "category_poster_304x237_yourweeklyaddress.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/weekly-addresses/rss.xml"
                  },
                  { Title: "White House Press Briefings",
                    SDPosterUrl: "category_poster_304x237_pressbriefings.jpg",
                    HDPosterUrl: "category_poster_304x237_pressbriefings.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/press-briefings/rss.xml"
                  },
                  { Title: "Speeches and Events",
                    SDPosterUrl: "category_poster_304x237_speechesandevents.jpg",
                    HDPosterUrl: "category_poster_304x237_speechesandevents.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/speeches/rss.xml"
                  },
                  { Title: "White House Features",
                    HDPosterUrl: "category_poster_304x237_features.jpg",
                    SDPosterUrl: "category_poster_304x237_features.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/white-house-features/rss.xml"
                  },
                  { Title: "West Wing Week",
                    SDPosterUrl: "category_poster_304x237_westwingweek.jpg",
                    HDPosterUrl: "category_poster_304x237_westwingweek.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/west-wing-week/rss.xml"
                  },
                  { Title: "The First Lady",
                    SDPosterUrl: "category_poster_304x237_firstlady.jpg",
                    HDPosterUrl: "category_poster_304x237_firstlady.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/the-first-lady/rss.xml"
                  },
                  { Title: "Music and Arts in the White House",
                    SDPosterUrl: "category_poster_304x237_musicandarts.jpg",
                    HDPosterUrl: "category_poster_304x237_musicandarts.jpg",
                    rssUrl: "http://www.whitehouse.gov/podcast/video/music-and-the-arts-at-the-white-house/rss.xml"
                  },
                  { Title: "Open For Questions",
                    SDPosterUrl: "category_poster_304x237_openquestions.jpg",
                    HDPosterUrl: "category_poster_304x237_openquestions.jpg",
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
        if msg.isListItemSelected() then
            print msg.GetIndex()
        end if
    
    end while

End Function
