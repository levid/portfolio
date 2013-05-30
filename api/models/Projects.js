/*---------------------
	:: Project
	-> model
---------------------*/
module.exports = {

	attributes: {

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

    url: {
      type: 'STRING'
    },

    description: {
      type: 'ARRAY'
    },

    date: {
      type: 'DATE'
    },

    image_ids: {
      type: 'STRING'
    },

    image: {
      type: 'STRING'
    },

    tag_ids: {
      type: 'STRING'
    },

    client_id: {
      type: 'STRING'
    },

    category_ids: {
      type: 'STRING'
    },

    slug: {
      type: 'STRING'
    }

	}
};