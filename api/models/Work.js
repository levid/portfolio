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


		image_ids: {
			type: 'STRING'
		},


		tag_ids: {
			type: 'ARRAY'
		},


		client_id: {
			type: 'STRING'
		},


		project_ids: {
			type: 'STRING'
		},


		category_ids: {
			type: 'STRING'
		}

	}
};
