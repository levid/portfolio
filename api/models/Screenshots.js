/*---------------------
  :: Screenshot
  -> model
---------------------*/
module.exports = {

  attributes  : {

    // Simple attribute:
    // name: 'STRING',

    // Or for more flexibility:
    // phoneNumber: {
    //  type: 'STRING',
    //  defaultValue: '555-555-5555'
    // }

    screenshot_thumbnail: {
      type: 'STRING'
    },

    screenshot_large: {
      type: 'STRING'
    },

    description: {
      type: 'STRING'
    },

    screenable_id: {
      type: 'STRING'
    }

  }

};