"use strict"

###
Defines application-wide key value pairs
###
Application.Constants.constant "configuration",
  s3_path: "https://s3.amazonaws.com/levidportfolio/uploads"
  audio: true
  notifications: true unless isMobile.any() and isMobile.excludeTablets() is true
  shuffle_letters: true