/*---------------------
	:: Image
	-> model
---------------------*/
module.exports = {

	attributes	: {

		// Simple attribute:
		// name: 'STRING',

		// Or for more flexibility:
		// phoneNumber: {
		//	type: 'STRING',
		//	defaultValue: '555-555-5555'
		// }

    name: {
      type: 'STRING'
    },

    format: {
      type: 'STRING'
    },

    image: {
      type: 'STRING'
    },

    preview_image: {
      type: 'STRING'
    },

    thumbnail_image: {
      type: 'STRING'
    },

    large_image: {
      type: 'STRING'
    },

    composite_image_desktop: {
      type: 'STRING'
    },

    composite_image_laptop: {
      type: 'STRING'
    },

    composite_image_tablet: {
      type: 'STRING'
    },

    screenshot_ids: {
      type: 'STRING'
    }

	}

};