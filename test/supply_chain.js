const SupplyChain = artifacts.require('SupplyChain');

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract('SupplyChain', async (accounts) => {
	const manufacturer = {
		name: 'ManufacturerX',
		password: 'pass123',
		address: '0xA35df34bdc9788366298C5905b7AB591D773aee0',
		type: 'Manufacturer',
	};
	const supplier = {
		name: 'SupplierX',
		password: 'pass345',
		address: '0xc17668035Ec95F1C82dd06392f6C117864B2BfeA',
		type: 'Supplier',
	};
	const consumer = {
		name: 'ConsumerX',
		password: 'pass678',
		address: '0x1F7ff13475a75A086A172526Ca6F76C7938A1839',
		type: 'Consumer',
	};

	it('should create a Participant', async () => {
		let instance = await SupplyChain.deployed();

		let participantId = await instance.addParticipant(
			manufacturer.name,
			manufacturer.password,
			manufacturer.address,
			manufacturer.type
		);
		let participant = await instance.getParticipant(0);
		assert.equal(participant[0], 'ManufacturerX');
		assert.equal(participant[2], 'Manufacturer');

		participantId = await instance.addParticipant(
			supplier.name,
			supplier.password,
			supplier.address,
			supplier.type
		);
		participant = await instance.getParticipant(1);
		assert.equal(participant[0], 'SupplierX');
		assert.equal(participant[2], 'Supplier');

		participantId = await instance.addParticipant(
			consumer.name,
			consumer.password,
			consumer.address,
			consumer.type
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
