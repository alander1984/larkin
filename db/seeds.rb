# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
	adminRole = Role.create({code:'admin',name: 'Administrator'});
	dispRole = Role.create({code:'disp',name: 'Dispetcher'});
	driverRole = Role.create({code:'driver',name: 'Driver'});

	admin = Worker.create({email: 'admin@cc.co', password: '12345678', password_confirmation: '12345678', name: 'Bruce Willis'});
	admin.roles << adminRole;
	admin.roles << dispRole;
	admin.save;	
	disp1 = Worker.create({email: 'dispetcher@cc.co', password: '12345678', password_confirmation: '12345678', name: 'Fata Morgana'})
	disp1.roles << dispRole;
	disp1.save;
	driver1 = Worker.create({email: 'driver1@cc.co', password: '12345678', password_confirmation: '12345678', name: 'Michael Shumacher'})
	driver2 = Worker.create({email: 'driver2@cc.co', password: '12345678', password_confirmation: '12345678', name: 'Fernando Alonso'})
	driver1.roles << driverRole;
	driver2.roles << driverRole;
	driver1.save;
	driver2.save;

