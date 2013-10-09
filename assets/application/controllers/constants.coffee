"use strict"

###
Defines application-wide key value pairs
###
Application.Constants.constant "configuration",
  s3_path: "http://d3v4bw9ncf327m.cloudfront.net/uploads"
  audio: true
  notifications: true unless isMobile.any() and isMobile.excludeTablets() is true
  shuffle_letters: true