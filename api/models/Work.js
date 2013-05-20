/*---------------------
	:: Work
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


		category: {
			type: 'STRING'
		},


		tags: {
			type: 'ARRAY'
		},


		client: {
			type: 'STRING'
		},


		web_address: {
			type: 'STRING'
		},


		description: {
			type: 'STRING'
		},


		thumbnail_image: {
			type: 'STRING'
		},


		large_image: {
			type: 'STRING'
		},

    images: {
      thumbnails: [],
      large_images: []
    },

		date: {
			type: 'DATE'
		}
	}

};