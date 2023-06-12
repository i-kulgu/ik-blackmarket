# ik-blackmarket
## QBCore QB-Menu + QB-Input based black market script

If you like my work and want to support me : [![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/F2F3EU9ME)

Used the same logic as the qb-shops so the config is self explanatory.

( For any help you can reach us at Discord: [Hi-Dev](https://discord.com/invite/pSJPPctrNx) )

- Easy to setup items
- Multiple blackmarkets supported
- Random or fixed locations (when random, location changes after each script restart)
- Multiple checks for inventory size and slot limits
- Localisation : Translated to languages ; English, Dutch and Turkish
- Ability to open the shop with a configured item
- Ability to use black money (markedbills or other itemname) or Q-Bit as payment method
- When using the blackmoney option, you can add a multiplier to the price if you want to sell items for more when paid by blackmoney.
- Random item option, if you set this on true your blackmarket will get a random item from your list. If you have disabled random location then all your markets will get different random items.
- Option to use a timer for changing the location of the black market after X amount of minutes
- Optional minigames to wiretap and get the blackmarket location

V2 video : https://youtu.be/xE6KSBT2DzI

Item needed:

```lua
	["crocodile_clips"] 			 = {["name"] = "crocodile_clips", 			["label"] = "Crocodile Clips", 	   			["weight"] = 150, 		["type"] = "item", 		["image"] = "crocodile_clips.png", 			["unique"] = false,   	["useable"] = false,   	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "Do some wiring work..", },
```

item image:

![crocodile_clips](https://user-images.githubusercontent.com/29943243/224580582-212a16a4-3a90-46d7-91f8-d9c937ec7b79.png)


![image1](https://media.discordapp.net/attachments/955865077532209156/986773108990021632/unknown.png)
![image2](https://media.discordapp.net/attachments/986773374602711100/986773981619163166/unknown.png)


This is an edited version of [jim-shops](https://github.com/jimathy/jim-shops)
Wire minigame : [minigameFixWiring](https://github.com/mxlolshop/minigameFixWiring)
