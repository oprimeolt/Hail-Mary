/////////////////
// POWER FISTS //
/////////////////		-Uses power (gas currently) for knockback. Heavy AP, specialized for attacking heavy armor

// Power Fist			Throws targets. Max damage 52. Full AP.
/obj/item/melee/powerfist/f13
	name = "power fist"
	desc = "A metal gauntlet with a piston-powered ram on top for that extra 'oomph' in your punch."
	icon_state = "powerfist"
	item_state = "powerfist"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	flags_1 = CONDUCT_1
	attack_verb = list("whacked", "fisted", "power-punched")
	force = 30 //needs more hefty damage to be worthwhile outside pvp. will have to test
	throwforce = 10
	throw_range = 3
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_GLOVES
	var/transfer_prints = TRUE //prevents runtimes with forensics when held in glove slot
	var/throw_distance = 1
	attack_speed = CLICK_CD_MELEE

/obj/item/melee/powerfist/f13/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/wrench))
		switch(fisto_setting)
			if(1)
				fisto_setting = 1.5
			if(2)
				fisto_setting = 1
		W.play_tool_sound(src)
		to_chat(user, span_notice("You tweak \the [src]'s piston valve to [fisto_setting]."))
		attack_speed = CLICK_CD_MELEE * fisto_setting

/obj/item/melee/powerfist/f13/updateTank(obj/item/tank/internals/thetank, removing = 0, mob/living/carbon/human/user)
	return

/obj/item/melee/powerfist/f13/attack(mob/living/target, mob/living/user, attackchain_flags = NONE)
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You don't want to harm other living beings!"))
		return FALSE
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	var/totalitemdamage = target.pre_attacked_by(src, user)
	target.apply_damage(totalitemdamage * fisto_setting, BRUTE, wound_bonus = -25*fisto_setting**2)
	target.visible_message(span_danger("[user]'s powerfist lets out a loud hiss as [user.p_they()] punch[user.p_es()] [target.name]!"), \
		span_userdanger("You cry out in pain as [user]'s punch flings you backwards!"))
	new /obj/effect/temp_visual/kinetic_blast(target.loc)
	playsound(loc, 'sound/weapons/resonator_blast.ogg', 50, 1)
	playsound(loc, 'sound/weapons/genhit2.ogg', 50, 1)
	var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
	target.throw_at(throw_target, 2 * throw_distance, 0.5 + (throw_distance / 2))
	log_combat(user, target, "power fisted", src)


// Dual Powerfist			Powerfist with lowered attack delay and increased throw distance
/obj/item/melee/powerfist/f13/dual
	name = "Dual Powerfists"
	desc = "A pair of metal gauntlets with a piston-powered ram on top for that extra 'oomph' in your punch."
	icon = 'icons/fallout/objects/melee/melee.dmi'
	lefthand_file = 'icons/fallout/onmob/clothes/hand.dmi'
	righthand_file = 'icons/fallout/onmob/clothes/hand.dmi'
	icon_state = "powerfist_dual"
	item_state = "powerfist_dual"
	force = 30 //EXPERIMENTAL FOR DUAL MELEES
	throw_distance = 2
	attack_speed = CLICK_CD_MELEE * 0.6
	w_class = WEIGHT_CLASS_BULKY

/obj/item/melee/powerfist/f13/dual/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user) && user.mind && slot == SLOT_HANDS)
		ADD_TRAIT(user, TRAIT_CLUMSY, CLOTHING_TRAIT)

/obj/item/melee/powerfist/f13/dual/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_CLUMSY, CLOTHING_TRAIT)

// Goliath				Throws targets far. Max damage 50.
/obj/item/melee/powerfist/f13/goliath
	name = "Goliath"
	desc = "A massive, experimental metal gauntlet crafted by some poor bastard in Redwater that since outlived their usefulness. The piston-powered ram on top is designed to throw targets very, very far."
	icon = 'icons/fallout/objects/melee/melee.dmi'
	lefthand_file = 'icons/fallout/onmob/weapons/melee1h_lefthand.dmi'
	righthand_file = 'icons/fallout/onmob/weapons/melee1h_righthand.dmi'
	icon_state = "goliath"
	item_state = "goliath"
	force = 35 //needs to fuckin slapp
	throw_distance = 3

// Dual Goliath			Goliath with lowered attack delay and increased throw distance
/obj/item/melee/powerfist/f13/dual/goliath
	name = "Dual Goliaths"
	desc = "A pair of massive, experimental metal gauntlets crafted by some poor bastard in Redwater that since outlived their usefulness. The piston-powered ram on top is designed to throw targets very, very far."
	icon = 'icons/fallout/objects/melee/melee.dmi'
	lefthand_file = 'icons/fallout/onmob/clothes/hand.dmi'
	righthand_file = 'icons/fallout/onmob/clothes/hand.dmi'
	icon_state = "goliath_dual"
	item_state = "goliath_dual"
	force = 35 //EXPERIMENTAL FOR DUAL MELEES
	throw_distance = 4
	w_class = WEIGHT_CLASS_BULKY

/obj/item/melee/powerfist/f13/dual/goliath/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user) && user.mind && slot == SLOT_HANDS)
		ADD_TRAIT(user, TRAIT_CLUMSY, CLOTHING_TRAIT)

/obj/item/melee/powerfist/f13/dual/goliath/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_CLUMSY, CLOTHING_TRAIT)

// Ballistic Fist			Keywords: Damage max 42, Shotgun
/obj/item/gun/ballistic/revolver/ballisticfist
	name = "ballistic fist"
	desc = "This powerfist has been modified to have two shotgun barrels welded to it, with the trigger integrated into the knuckle guard. For those times when you want to punch someone and shoot them in the face at the same time."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "ballisticfist"
	item_state = "powerfist"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	force = 30
	armour_penetration = 0
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual
	fire_sound = 'sound/f13weapons/caravan_shotgun.ogg'
	slot_flags =  ITEM_SLOT_BELT | ITEM_SLOT_GLOVES
	w_class = WEIGHT_CLASS_NORMAL
	item_flags = NEEDS_PERMIT //doesn't slow you down
	fire_delay = 0
	var/transfer_prints = TRUE //prevents runtimes with forensics when held in glove slot

// Dual Ballistic Fist			Keywords: Damage max 42, Shotgun
/obj/item/gun/ballistic/revolver/ballisticfist/dual
	name = "Dual ballistic fists"
	desc = "These powerfists has been modified to have two shotgun barrels welded to it, with the trigger integrated into the knuckle guard. For those times when you want to punch someone and shoot them in the face at the same time."
	icon = 'icons/fallout/objects/melee/melee.dmi'
	icon_state = "ballisticfist_dual"
	item_state = "ballisticfist_dual"
	lefthand_file = 'icons/fallout/onmob/clothes/hand.dmi'
	righthand_file = 'icons/fallout/onmob/clothes/hand.dmi'
	force = 30
	armour_penetration = 0
	mag_type = /obj/item/ammo_box/magazine/internal/shot
	fire_sound = 'sound/f13weapons/caravan_shotgun.ogg'
	slot_flags =  ITEM_SLOT_GLOVES
	w_class = WEIGHT_CLASS_NORMAL
	item_flags = NEEDS_PERMIT //doesn't slow you down
	fire_delay = 0
	w_class = WEIGHT_CLASS_BULKY

/obj/item/gun/ballistic/revolver/ballisticfist/dual/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user) && user.mind && slot == SLOT_HANDS)
		ADD_TRAIT(user, TRAIT_CLUMSY, CLOTHING_TRAIT)

/obj/item/gun/ballistic/revolver/ballisticfist/dual/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_CLUMSY, CLOTHING_TRAIT)


// Mole Miner
/obj/item/melee/powerfist/f13/moleminer
	name = "mole miner gauntlet"
	desc = "A hand-held mining and cutting implement, repurposed into a deadly melee weapon.  Its name origins are a mystery..."
	icon_state = "mole_miner_g"
	item_state = "mole_miner_g"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	flags_1 = CONDUCT_1
	force = 25 //It shouldn't be both a mid fist weapon and a digging tool dangit! Especially for the resources it takes! 5 less dmg than a power fist
	throwforce = 10
	throw_range = 7
	attack_verb = list("slashed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	tool_behaviour = TOOL_MINING
	var/digrange = 1 //This should give it the 3x1 dig range that drills and some picks have
	toolspeed = 0.3 //This should make it dig really quick. Like a moleminer!
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_GLOVES
	armor = ARMOR_VALUE_GENERIC_ITEM


/////////////////////
// ADVANCED SWORDS //
/////////////////////

// Ripper				Keywords: Damage 10/45, Wound bonus, block
/obj/item/melee/powered/ripper
	name = "ripper"
	desc = "The Ripper™ vibroblade is powered by a small energy cell wich allows it to easily cut through flesh and bone."
	icon = 'icons/fallout/objects/melee/melee.dmi'
	icon_state = "ripper"
	lefthand_file = 'icons/fallout/onmob/weapons/melee1h_lefthand.dmi'
	righthand_file = 'icons/fallout/onmob/weapons/melee1h_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	total_mass = TOTAL_MASS_MEDIEVAL_WEAPON
	slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BELT
	force = 10
	wound_bonus = 25
	block_chance = 15
	throw_speed = 3
	throw_range = 4
	throwforce = 10
	tool_behaviour = TOOL_SAW
	sharpness = SHARP_EDGED
	toolspeed = 1.5
	resistance_flags = FIRE_PROOF
	hitsound = 'sound/weapons/chainsawhit.ogg'
	var/on_item_state = "ripper_on"
	var/off_item_state = "ripper"
	var/weight_class_on = WEIGHT_CLASS_HUGE
	var/force_on = 45
	var/force_off = 10
	var/on = FALSE
	var/on_icon_state = "ripper_on"
	var/off_icon_state = "ripper"
	var/on_sound = 'sound/weapons/chainsawhit.ogg'
	var/description_on = "<span class ='warning'>You thumb the on button, the whining, blurry edge of the Ripper now lethal to touch.</span>"
	var/description_off = "<span class ='notice'>You turn off the Ripper, the buzz of the cutting teeth ceasing.</span>"

/obj/item/melee/powered/ripper/attack_self(mob/user)
	on = !on
	to_chat(user, description_on)
	if(on)
		to_chat(user, description_on)
		icon_state = on_icon_state
		item_state = on_item_state
		w_class = weight_class_on
		force = force_on
		slot_flags = null
		attack_verb = list("sawed", "torn", "cut", "chopped", "diced")
		playsound(loc, on_sound, 50, TRUE)
	else
		to_chat(user, description_off)
		icon_state = off_icon_state
		item_state = off_item_state
		w_class = WEIGHT_CLASS_NORMAL
		force = force_off
		slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BELT
		attack_verb = list("poked", "scraped")
	add_fingerprint(user)


//Warhammer chainsword			Keywords: Damage 10/50, Wound bonus, Block, Bonus AP + 0.15
/obj/item/melee/powered/ripper/prewar
	name = "pre-war military ripper"
	desc = "A hand-held, militarized chainsaw, popular with Army units requiring a compact engineering tool for cutting. Just what material is intended to be cut with the weapon remains open to debate."
	icon_state = "prewarrip_off"
	on_icon_state = "prewarrip_on"
	off_icon_state = "prewarrip_off"
	on_item_state = "prewarrip_on"
	off_item_state = "prewarrip_off"
	force_on = 50
	armour_penetration = 0.15


// Shishkebab backpack				The shishkebab weapon base unit
/obj/item/shishkebabpack
	name = "shishkebab backpack"
	desc = "A backpack containing a large quantity of fuel and a pipe attaching it to a long, deadly blade. You ever wanted to set fire to people with a sword?"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "shishkebabpack"
	item_state = "shishkebabpack"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
//	actions_types = list(/datum/action/item_action/toggle_shishkebab)
	armor = ARMOR_VALUE_GENERIC_ITEM
	resistance_flags = FIRE_PROOF

	var/obj/item/sword

/obj/item/shishkebabpack/Initialize()
	. = ..()
	sword = make_sword()

/obj/item/shishkebabpack/ui_action_click(mob/user)
	toggle_shishkebab(user)

/obj/item/shishkebabpack/item_action_slot_check(slot, mob/user)
	if(slot == user.getBackSlot())
		return 1

/obj/item/shishkebabpack/proc/toggle_shishkebab(mob/living/user)
	if(!istype(user))
		return
	if(user.get_item_by_slot(user.getBackSlot()) != src)
		to_chat(user, span_warning("The backpack must be worn properly to use!"))
		return
	if(user.incapacitated())
		return

	if(QDELETED(sword))
		sword = make_sword()
	if(sword in src)
		//Detach the sword into the user's hands
		if(!user.put_in_hands(sword))
			to_chat(user, span_warning("You need a free hand to hold the shishkebab!"))
			return
	else
		//Remove from their hands and put back "into" the tank
		remove_sword()

/obj/item/shishkebabpack/verb/toggle_shishkebab_verb()
	set name = "Toggle Shishkebab"
	set category = "Object"
	toggle_shishkebab(usr)

/obj/item/shishkebabpack/proc/make_sword()
	return new /obj/item/weapon/melee/shishkebab(src)

/obj/item/shishkebabpack/equipped(mob/user, slot)
	..()
	if(slot != SLOT_BACK)
		remove_sword()

/obj/item/shishkebabpack/proc/remove_sword()
	if(ismob(sword.loc))
		var/mob/M = sword.loc
		M.temporarilyRemoveItemFromInventory(sword, TRUE)
	sword.forceMove(src)

/obj/item/shishkebabpack/Destroy()
	QDEL_NULL(sword)
	return ..()

/obj/item/shishkebabpack/attack_hand(mob/user)
	if (user.get_item_by_slot(user.getBackSlot()) == src)
		toggle_shishkebab(user)
	else
		return ..()

/obj/item/shishkebabpack/MouseDrop(obj/over_object)
	var/mob/M = loc
	if(istype(M) && istype(over_object, /obj/screen/inventory/hand))
		var/obj/screen/inventory/hand/H = over_object
		M.putItemFromInventoryInHandIfPossible(src, H.held_index)
	return ..()

/obj/item/shishkebabpack/attackby(obj/item/W, mob/user, params)
	if(W == sword)
		remove_sword()
		return 1
	else
		return ..()

/obj/item/shishkebabpack/dropped(mob/user)
	..()
	remove_sword()

// Shishkebab sword				Keywords: Damage 55 (fire), Tool welder
/obj/item/weapon/melee/shishkebab //This should never exist without the backpack.
	name = "shishkebab"
	desc = "A deadly flaming sword covered in fuel. You're not sure this is entirely safe."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "shishkebab"
	item_state = "shishkebab"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	item_flags = ABSTRACT  // don't put in storage
	slot_flags = 0
	force = 55
	damtype = "fire"
	tool_behaviour = TOOL_WELDER
	toolspeed = 0.3

	var/obj/item/shishkebabpack/tank

/obj/item/weapon/melee/shishkebab/Initialize()
	. = ..()
	tank = loc
	if(!istype(tank))
		return INITIALIZE_HINT_QDEL

/obj/item/weapon/melee/shishkebab/attack_self()
	return

/obj/item/weapon/melee/shishkebab/doMove(atom/destination)
	if(destination && (destination != tank.loc || !ismob(destination)))
		if (loc != tank)
			to_chat(tank.loc, span_notice("The shishkebab slides back into the backpack tank."))
		destination = tank
	..()
