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


		url: {
			type: 'STRING'
		},


		description: {
			type: 'STRING'
		},


    images: {
      type: 'ARRAY',
      preview: {type: 'ARRAY'},
      thumbnails: {type: 'ARRAY'},
      large: {type: 'ARRAY'}
    },


		date: {
			type: 'DATE'
		}
	}

};