/*---------------------
	:: Theme
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

    position: {
      type: 'STRING'
    },

		background_image: {
			type: 'STRING'
		},

		thumbnail_image: {
			type: 'STRING'
		},

    is_active: {
      type: 'BOOLEAN'
    },

    is_default: {
      type: 'BOOLEAN'
    }
	}

};