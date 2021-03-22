# Escutcheons

An addon that helps to track your progress on making an escutcheon Shield on the final phase
1. It automatically trigger crafting of the item when it is detected to drop
2. It automatically keep tracks of desynthesis attempts and losts, number of T1, T2 and T3 spheres obtained 
3. It automatically keep tracks of the spirits imbued or lost
4. It automatically keep tracks of the number of catalysts used

### Commands

Note:
All commands can be shortened to `//ec`.

`ec help`

List help of commands

`ec stats`

List of stats collected

`ec autocraft <true|false>`

Enable automatic crafting of items in inventory, this uses the craft add-on
  
`ec autosave <true|false>`

Automatically save the stats collected whenever updated

`ec delay <delay seconds>`

Set the delay after combat to start autocrafting

`ec recheck <delay seconds>`

Set the delay after crafting to check whether to perform again

`ec craftset <equipset number 1-20>`

Switch to equipset when crafting

`ec defaultset <equipset number 1-20>`

Switch to equipset after crafting

`ec save`

Save the collected stats and setting changes

`ec verbose <true|false>`

Toggle more messages to be printed, more for debugging than anything

