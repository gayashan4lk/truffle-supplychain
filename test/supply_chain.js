const SupplyChain = artifacts.require('SupplyChain');

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract('SupplyChain', async (accounts) => {
	it('should create a Participant', async () => {
		let instance = await SupplyChain.deployed();

		let participantId = await instance.addParticipant(
			'ManufacturerX',
			'pass123',
			'0x85581dEB412A791Abfb5092ff8f452fb03109Fcc',
			'Manufacturer'
		);
		let participant = await instance.getParticipant(0);
		assert.equal(participant[0], 'ManufacturerX');
		assert.equal(participant[2], 'Manufacturer');

		participantId = await instance.addParticipant(
			'SupplierX',
			'pass345',
			'0xbe9A743D53CE57731589Bd23ee0013aa26028B7D',
			'Supplier'
		);
		participant = await instance.getParticipant(1);
		assert.equal(participant[0], 'SupplierX');
		assert.equal(participant[2], 'Supplier');

		participantId = await instance.addParticipant(
			'ConsumerX',
			'pass345',
			'0x3F87CAb3040B511768e44B80b042E4EC35ea24bC',
			'Consumer'
		);
		participant = await instance.getParticipant(2);
		assert.equal(participant[0], 'ConsumerX');
		assert.equal(participant[2], 'Consumer');
	});

	it('should return participant details', async () => {
		let instance = await SupplyChain.deployed();
		let participantDetails = await instance.getParticipant(0);
		assert.equal(participantDetails[0], 'ManufacturerX');

		instance = await SupplyChain.deployed();
		participantDetails = await instance.getParticipant(1);
		assert.equal(participantDetails[0], 'SupplierX');

		instance = await SupplyChain.deployed();
		participantDetails = await instance.getParticipant(2);
		assert.equal(participantDetails[0], 'ConsumerX');
	});
});
