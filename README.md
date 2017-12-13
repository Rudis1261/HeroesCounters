## Heroes Counters

My attempt at creating an application to help you choose the correct character when playing the game "Heroes Of The Storm"

1. What constitutes a counter?
	- When a hero if vulnerable to a specific trait
	- When a hero is does not have escapes
	- A hero does not have any form of self sustain
	- Damage potential
	- Counters 1+ other heroes in a match

2. Hero traits to consider
 	- Self healing
 	- Auto attack
 	- High spell damage
	- High health
	- % based damage
	- Blinds
	- Stasis (Stasis, Trapped, Eaten, VP, Temporal Loop, Root)
	- Protected
	- Has cleanse
	- Iceblock
	- Mobility
	- High siege dmg
	- Invulnerable
	- Kill resets
	- Map strengths
	- Unstoppable
	- Invisible
	- Reveals
	- Shields
	- Blink
	- Slows
	- Stuns

2.1. Asigning a value to the above mentioned traits.

3. What makes a specific hero more relevant?
	- Is relevant when it's trait directly competes with another hero's trait
	- A hero is relevant when it, itself is not countered by the enemy team
	- Strong on the map

4. Very specific counters
	- Well known counters to specific heroes.
		- Tracer V.S Maltheal
		- Kerigan V.S Hammer
		- Maltheal / Leoric V.S ChoGal

5. Corelation
	- Assigning all the properties on a per hero basis
	- Creating a map of counters
	- Missing key role
	- Working out when you need more tanks
	- Working out when you need double support


### Bundle

```shell
# Bundle install all the things
bundle install
```
### Rake
```shell
# To see the ActiveRecord options
bundle exec rake -T

# When starting off you might want to create the DB
bundle exec rake db:create

# Running migrations
bundle exec rake db:migrate

# You might also want to seed the database with some data
bundle exec rake db:seed

# You can also run a test with a rake task
rake test
```

### Tests

```shell
# Running tests (Automatically with notifications)
autotest --style=rspec
```