local assets = {}

local textures = {
	init = {
		{ "gallerySlider",   "assets/gallery/slider.png" },
		{ "galleryVolume",   "assets/gallery/volume.png" },
		{ "galleryPlay",     "assets/gallery/play.png" },
		{ "galleryNext",     "assets/gallery/next.png" },
		{ "galleryPrevious", "assets/gallery/previous.png" },
		{ "galleryPause",    "assets/gallery/pause.png" },
		{ "gui_gallery",     "assets/android/gui_gallery.png" },
		{ "wits",            "assets/images/wits.png" },
		{ "splash",          "assets/images/splash-anim-sheet.png" },
		{ "gui_sound",       "assets/android/gui_sound.png" },
		{ "gui_sound_off",   "assets/android/gui_sound_off.png" },
		{ "adIntro",         "assets/android/adIntro.png" },
		{ "gui_quit",        "assets/android/gui_quit.png" },
		{ "gui_sBack",       "assets/android/gui_sBack.png" },
		{ "gui_settings",    "assets/android/gui_settings.png" },
		{ "gui_joystick",    "assets/android/gui_joystick.png" },
		{ "gui_left",        "assets/android/gui_left.png" },
		{ "gui_right",       "assets/android/gui_right.png" },
		{ "gui_act",         "assets/android/gui_act.png" },
		{ "gui_light",       "assets/android/gui_light.png" },
		{ "gui_up",          "assets/android/gui_up.png" },
		{ "gui_down",        "assets/android/gui_down.png" },
		{ "gui_enter",       "assets/android/gui_enter.png" },
		{ "gui_esc",         "assets/android/gui_esc.png" },
		{ "website_gui",     "assets/website_gui.png" },
		{ "email",           "assets/email.png" },
		{ "twitter",         "assets/twitter.png" },
		{ "paypal",          "assets/paypal.png" },
		{ "question",        "assets/question.png" },
		{ "skip",            "assets/skip.png" },
		{ "instruction_gui", "assets/instruction_gui.png" },
		{ "return_gui",      "assets/return_gui.png" },
		{ "about",           "assets/about.png" },
		{ "options",         "assets/options.png" },
		{ "start",           "assets/start.png" },
		{ "exit",            "assets/exit.png" },
		{ "bg",              "assets/images/bg.png" },
		{ "title_text",      "assets/images/title_text.png" },
		{ "basementRoom",    "assets/images/basementRoom.png" },
	},

	intro = {
		{ "car_moving",  "assets/images/intro_1-sheet.png" },
		{ "player_door", "assets/images/intro_2-sheet.png" },
		{ "in_house",    "assets/images/intro_3-sheet.png" },
	},

	main = {
		{ "lightOutlineSmall",      "assets/android/lightOutlineSmall.png" },
		{ "light3",                 "assets/android/light3.png" },
		{ "lightOutline",           "assets/android/lightOutline.png" },
		{ "enemy_dead_sheet",       "assets/images/enemy_dead_sheet.png" },
		{ "player_killed_sheet",    "assets/images/player_killed_sheet.png" },
		{ "note",                   "assets/images/note.png" },
		{ "note_glow",              "assets/images/note_glow.png" },
		{ "f_shot_sheet",           "assets/images/f_shot.png" },
		{ "leaving home",           "assets/images/check1.png" },
		{ "destroying home",        "assets/images/check2.png" },
		{ "saving home",            "assets/images/check3.png" },
		{ "f_leave",                "assets/images/f_leave-sheet.png" },
		{ "f1",                     "assets/images/f_sit_stand-sheet.png" },
		{ "jail",                   "assets/images/jail.png" },
		{ "br",                     "assets/images/br.png" },
		{ "br_glow",                "assets/images/br_glow.png" },
		{ "player_panic_sheet",     "assets/images/player_panic.png" },
		{ "father_sheet",           "assets/images/es_father-sheet.png" },
		{ "mother_sheet",           "assets/images/es_mother-sheet.png" },
		{ "shoot_pose_sheet",       "assets/images/shoot_pose-sheet.png" },
		{ "reload_sheet",           "assets/images/reload-sheet.png" },
		{ "leave_sheet",            "assets/images/leave-sheet.png" },
		{ "wait_sheet",             "assets/images/wait-sheet.png" },
		{ "dust",                   "assets/images/dust.png" },
		{ "overlay",                "assets/images/secretRoom_overlay.png" },
		{ "light",                  "assets/images/light.png" },
		{ "light2",                 "assets/images/light2.png" },
		{ "light_small",            "assets/images/light_small.png" },
		{ "player_idle",            "assets/images/player_idle.png" },
		{ "player_red_eyes",        "assets/images/player_red_eyes.png" },
		{ "player_eyes_bleed",      "assets/images/player_eyes_bleed.png" },
		{ "player_dead",            "assets/images/player_dead.png" },
		{ "player_down",            "assets/images/player_down.png" },
		{ "player_child_sheet",     "assets/images/player_child-sheet.png" },
		{ "player_child_idle",      "assets/images/player_child_idle.png" },
		{ "player_child_push",      "assets/images/player_child_push-sheet.png" },
		{ "player_sheet",           "assets/images/player-sheet.png" },
		{ "window_left",            "assets/images/window_left-sheet.png" },
		{ "window_right",           "assets/images/window_right-sheet.png" },
		{ "endRoom",                "assets/images/endRoom.png" },
		{ "mainRoom",               "assets/images/mainRoom.png" },
		{ "kitchen",                "assets/images/kitchen.png" },
		{ "livingRoom",             "assets/images/livingRoom.png" },
		{ "stairRoom",              "assets/images/stairRoom.png" },
		{ "masterRoom",             "assets/images/masterRoom.png" },
		{ "secretRoom",             "assets/images/secretRoom.png" },
		{ "hallwayLeft",            "assets/images/hallwayLeft.png" },
		{ "storageRoom",            "assets/images/storageRoom.png" },
		{ "hallwayRight",           "assets/images/hallwayRight.png" },
		{ "daughterRoom",           "assets/images/daughterRoom.png" },
		{ "atticRoom",              "assets/images/atticRoom.png" },
		{ "basementRoom",           "assets/images/basementRoom.png" },
		{ "leftRoom",               "assets/images/leftRoom.png" },
		{ "rightRoom",              "assets/images/rightRoom.png" },
		{ "right_light1",           "assets/images/rightRoom_light1.png" },
		{ "right_light2",           "assets/images/rightRoom_light2.png" },
		{ "right_light3",           "assets/images/rightRoom_light3.png" },
		{ "right_light4",           "assets/images/rightRoom_light4.png" },
		{ "left_light",             "assets/images/left_light.png" },
		{ "enemy_sheet",            "assets/images/enemy-sheet.png" },
		{ "m_shoerack",             "assets/images/m_shoerack.png" },
		{ "m_shelf",                "assets/images/m_shelf.png" },
		{ "lr_display",             "assets/images/lr_display.png" },
		{ "lr_portraits",           "assets/images/lr_portraits.png" },
		{ "st_landscape",           "assets/images/st_landscape.png" },
		{ "st_head",                "assets/images/st_head.png" },
		{ "st_hole",                "assets/images/st_hole.png" },
		{ "hl_stand",               "assets/images/hl_stand.png" },
		{ "hl_bench",               "assets/images/hl_bench.png" },
		{ "hl_ball",                "assets/images/hl_ball.png" },
		{ "store_cabinet",          "assets/images/store_cabinet.png" },
		{ "store_toolbox",          "assets/images/store_toolbox.png" },
		{ "store_bench",            "assets/images/store_bench.png" },
		{ "store_hoop",             "assets/images/store_hoop.png" },
		{ "store_hoop_ball",        "assets/images/store_hoop_ball.png" },
		{ "mast_candles",           "assets/images/mast_candles.png" },
		{ "hr_abstract",            "assets/images/hr_abstract.png" },
		{ "hr_surreal",             "assets/images/hr_surreal.png" },
		{ "dr_cabinet",             "assets/images/dr_cabinet.png" },
		{ "dr_crib",                "assets/images/dr_crib.png" },
		{ "dr_stuffs",              "assets/images/dr_stuffs.png" },
		{ "k_table",                "assets/images/k_table.png" },
		{ "k_ref",                  "assets/images/k_ref.png" },
		{ "k_trash",                "assets/images/k_trash.png" },
		{ "k_sink",                 "assets/images/k_sink.png" },
		{ "bed",                    "assets/images/secret_bed.png" },
		{ "vault",                  "assets/images/secret_vault.png" },
		{ "rope",                   "assets/images/secret_rope.png" },
		{ "tv",                     "assets/images/secret_tv.png" },
		{ "open_vault",             "assets/images/secret_open_vault.png" },
		{ "tv_anim",                "assets/images/secret_tv-sheet.png" },
		{ "m_shoerack_glow",        "assets/images/m_shoerack_glow.png" },
		{ "m_shelf_glow",           "assets/images/m_shelf_glow.png" },
		{ "lr_display_glow",        "assets/images/lr_display_glow.png" },
		{ "lr_portraits_glow",      "assets/images/lr_portraits_glow.png" },
		{ "st_landscape_glow",      "assets/images/st_landscape_glow.png" },
		{ "st_head_glow",           "assets/images/st_head_glow.png" },
		{ "st_hole_glow",           "assets/images/st_hole_glow.png" },
		{ "hl_stand_glow",          "assets/images/hl_stand_glow.png" },
		{ "hl_bench_glow",          "assets/images/hl_bench_glow.png" },
		{ "hl_ball_glow",           "assets/images/hl_ball_glow.png" },
		{ "store_cabinet_glow",     "assets/images/store_cabinet_glow.png" },
		{ "store_toolbox_glow",     "assets/images/store_toolbox_glow.png" },
		{ "store_bench_glow",       "assets/images/store_bench_glow.png" },
		{ "store_hoop_glow",        "assets/images/store_hoop_glow.png" },
		{ "store_hoop_ball_glow",   "assets/images/store_hoop_ball_glow.png" },
		{ "mast_candles_glow",      "assets/images/mast_candles_glow.png" },
		{ "hr_abstract_glow",       "assets/images/hr_abstract_glow.png" },
		{ "hr_surreal_glow",        "assets/images/hr_surreal_glow.png" },
		{ "dr_crib_glow",           "assets/images/dr_crib_glow.png" },
		{ "dr_stuffs_glow",         "assets/images/dr_stuffs_glow.png" },
		{ "dr_cabinet_glow",        "assets/images/dr_cabinet_glow.png" },
		{ "k_table_glow",           "assets/images/k_table_glow.png" },
		{ "k_ref_glow",             "assets/images/k_ref_glow.png" },
		{ "k_trash_glow",           "assets/images/k_trash_glow.png" },
		{ "k_sink_glow",            "assets/images/k_sink_glow.png" },
		{ "bed_glow",               "assets/images/secret_bed_glow.png" },
		{ "vault_glow",             "assets/images/secret_vault_glow.png" },
		{ "rope_glow",              "assets/images/secret_rope_glow.png" },
		{ "tv_glow",                "assets/images/secret_tv_glow.png" },
		{ "open_vault_glow",        "assets/images/secret_open_vault_glow.png" },
		{ "tv_light",               "assets/images/secret_tv_light.png" },
		{ "ladder",                 "assets/images/secret_ladder.png" },
		{ "ladder_glow",            "assets/images/secret_ladder_glow.png" },
		{ "corpse",                 "assets/images/spr_corpse.png" },
		{ "corpse_glow",            "assets/images/spr_corpse_glow.png" },
		{ "corpse_anim",            "assets/images/corpse_anim.png" },
		{ "clock_anim",             "assets/images/atticRoom_clock_anim.png" },
		{ "attic_room_ladder",      "assets/images/atticRoom_ladder.png" },
		{ "attic_room_ladder_glow", "assets/images/atticRoom_ladder_glow.png" },
		{ "chest",                  "assets/images/atticRoom_chest.png" },
		{ "chest_glow",             "assets/images/atticRoom_chest_glow.png" },
		{ "clock",                  "assets/images/atticRoom_clock.png" },
		{ "clock_glow",             "assets/images/atticRoom_clock_glow.png" },
		{ "clock_base",             "assets/images/clock_base.png" },
		{ "clock_digits",           "assets/images/clock_digits.png" },
		{ "clock_digits_glow",      "assets/images/clock_digits_glow.png" },
		{ "store_chair",            "assets/images/store_chair.png" },
		{ "store_chair_glow",       "assets/images/store_chair_glow.png" },
		{ "s_drawer",               "assets/images/s_drawer.png" },
		{ "s_drawer_glow",          "assets/images/s_drawer_glow.png" },
		{ "candles_light_mask",     "assets/images/candles_flash.png" },
		{ "pic1",                   "assets/images/pic1.png" },
		{ "pic2",                   "assets/images/pic2.png" },
		{ "pic3",                   "assets/images/pic3.png" },
		{ "pic4",                   "assets/images/pic4.png" },
		{ "arrow",                  "assets/images/arrow.png" },
		{ "storage_vault",          "assets/images/storage_vault.png" },
		{ "storage_vault_glow",     "assets/images/storage_vault_glow.png" },
		{ "input_base",             "assets/images/input_base.png" },
		{ "ammo",                   "assets/images/ammo.png" },
		{ "ammo_glow",              "assets/images/ammo_glow.png" },
		{ "left_light1",            "assets/images/left_light1.png" },
		{ "left_light2",            "assets/images/left_light2.png" },
		{ "m_shoerack_color",       "assets/images/m_shoerack_color.png" },
		{ "m_shelf_color",          "assets/images/m_shelf_color.png" },
		{ "lr_display_color",       "assets/images/lr_display_color.png" },
		{ "lr_portraits_color",     "assets/images/lr_portraits_color.png" },
		{ "basement_battery_color", "assets/images/basement_battery_color.png" },
		{ "player_sheet_color",     "assets/images/player-sheet_color.png" },
		{ "mainRoom_color",         "assets/images/mainRoom_color.png" },
		{ "livingRoom_color",       "assets/images/livingRoom_color.png" },
		{ "basementRoom_color",     "assets/images/basementRoom_color.png" },
		{ "window_left_color",      "assets/images/window_left-sheet_color.png" },
		{ "window_right_color",     "assets/images/window_right-sheet_color.png" },
		{ "battery",                "assets/images/battery.png" },
		{ "battery_glow",           "assets/images/battery_glow.png" },
	}
}

if not ON_MOBILE then
	table.insert(textures.main, {
		"basement_battery", "assets/images/basement_battery.png"
	})
	table.insert(textures.main, {
		"basement_battery_glow", "assets/images/basement_battery_glow.png"
	})
end

local sources = {
	init = {
		{ "intro_soft",    "assets/audio/intro_soft2.ogg",   "stream" },
		{ "finding_home",  "assets/audio/silent_bgm.ogg",    "stream" },
		{ "ts_theme",      "assets/audio/ts_bgm.ogg",        "stream" },
		{ "main_theme",    "assets/audio/finding_home.ogg",  "stream" },
		{ "they_are_gone", "assets/audio/they_are_gone.ogg", "stream" },
		{ "heartbeat",     "assets/audio/heartbeat.ogg", "static" },
	},

	intro = {
		{ "knock",        "assets/audio/knock.ogg",        "static" },
		{ "enemy_scream", "assets/audio/enemy_scream.ogg", "static" },
		{ "rain",         "assets/audio/rain.ogg",         "stream" },
		{ "thunder",      "assets/audio/thunder.ogg",      "static" },
		{ "unlock",       "assets/audio/unlock.ogg",       "static" },
	},

	main = {
		{ "smash_head",      "assets/audio/smash_head.ogg",     "static" },
		{ "grunt",           "assets/audio/grunt.ogg",          "static" },
		{ "gun_click",       "assets/audio/gun_click.ogg",      "static" },
		{ "gunshot",         "assets/audio/gunshot.ogg",        "static" },
		{ "lightning",       "assets/audio/lightning.ogg",      "static" },
		{ "reload",          "assets/audio/reload.ogg",         "static" },
		{ "door",            "assets/audio/door.ogg",           "static" },
		{ "squeak",          "assets/audio/squeak.ogg",         "static" },
		{ "door_fast",       "assets/audio/door_fast.ogg",      "static" },
		{ "squeak_fast",     "assets/audio/squeak_fast.ogg",    "static" },
		{ "locked",          "assets/audio/locked.ogg",         "static" },
		{ "item_got",        "assets/audio/item_got.ogg",       "static" },
		{ "wood_drop",       "assets/audio/wood_drop.ogg",      "static" },
		{ "air_pump",        "assets/audio/air_pump.ogg",       "static" },
		{ "ball_in_hoop",    "assets/audio/ball_in_hoop.ogg",   "static" },
		{ "enemy_mys_sound", "assets/audio/enemy_mys.ogg",      "static" },
		{ "enemy_chase",     "assets/audio/enemy_chase.ogg",    "static" },
		{ "re_sound",        "assets/audio/re_sound.ogg",       "static" },
		{ "match",           "assets/audio/match_strike.ogg",   "static" },
		{ "breath_1",        "assets/audio/breath1.ogg",        "static" },
		{ "breath_2",        "assets/audio/breath2.ogg",        "static" },
		{ "breath_3",        "assets/audio/breath3.ogg",        "static" },
		{ "fl_toggle",       "assets/audio/fl_toggle.ogg",      "static" },
		{ "crowbar",         "assets/audio/crowbar.ogg",        "static" },
		{ "tv_loud",         "assets/audio/tv.ogg",             "static" },
		{ "body_fall",       "assets/audio/body_fall.ogg",      "static" },
		{ "climb",           "assets/audio/climb.ogg",          "static" },
		{ "clock_tick",      "assets/audio/clock_tick.ogg",     "static" },
		{ "floor_squeak",    "assets/audio/floor_squeak.ogg",   "static" },
		{ "floor_hole",      "assets/audio/floor_hole.ogg",     "static" },
		{ "chair_move",      "assets/audio/chair_move.ogg",     "static" },
		{ "mother_scream",   "assets/audio/mother_scream.ogg",  "static" },
		{ "page1",           "assets/audio/page1.ogg",          "static" },
		{ "page2",           "assets/audio/page2.ogg",          "static" },
		{ "page3",           "assets/audio/page3.ogg",          "static" },
		{ "page4",           "assets/audio/page4.ogg",          "static" },
		{ "vault_unlock",    "assets/audio/vault_unlock.ogg",   "static" },
		{ "wrong_input",     "assets/audio/wrong_input.ogg",    "static" },
		{ "enter_key",       "assets/audio/enter_key.ogg",      "static" },
		{ "backspace_key",   "assets/audio/backspace_key.ogg",  "static" },
		{ "type",            "assets/audio/type.ogg",           "static" },
		{ "battery_refill",  "assets/audio/battery_refill.ogg", "static" },
	}
}

local loaded = {}

function assets.load()
	local state = gamestates.getState()
	local textures_to_load, sources_to_load

	if (state == "adshow") or (state == "splash") or (state == "splash2") or (state == "title") or (state == "gallery") or (state == "difficulty_select") then
		textures_to_load = textures.init
		sources_to_load = sources.init
	elseif (state == "rain_intro") or (state == "intro") or (state == "tutorial") then
		textures_to_load = textures.intro
		sources_to_load = sources.intro
	else
		textures_to_load = textures.main
		sources_to_load = sources.main
	end

	if loaded[textures_to_load] then
		local p = LOADER.getPending()
		for i = #p, 1, -1 do
			table.remove(p, i)
		end

		ON_LOAD_ASSETS()
		-- gamestates.init()
		return
	end

	FINISHED_LOADING = false
	for _, texture_data in ipairs(textures_to_load) do
		local key, path = unpack(texture_data)
		LOADER.newImage(IMAGES, key, path)
	end
	for _, source_data in ipairs(sources_to_load) do
		local key, path, kind = unpack(source_data)
		LOADER.newSource(SOUNDS, key, path, kind)
	end
	print("will load", gamestates.getState(), "with # of assets:", #LOADER.getPending())

	LOADER.start(function()
		ON_LOAD_ASSETS()
		loaded[textures_to_load] = true
	end)
end

function assets.set()
	ITEMS_LIST = {}
	DIALOGUES = {}

	assets.item_set()
	assets.dialogue_set()
	if ON_MOBILE then
		Android.load()
	end
end

function assets.item_set()
	--main room
	local shoerack = Items(IMAGES.m_shoerack, IMAGES["mainRoom"], 26, 36, "shoerack")
	local shelf = Items(IMAGES.m_shelf, IMAGES["mainRoom"], 90, 30, "shelf")
	--living room
	local display = Items(IMAGES.lr_display, IMAGES["livingRoom"], 22, 24, "displays")
	local portraits = Items(IMAGES.lr_portraits, IMAGES["livingRoom"], 80, 26, "portraits")
	--stair room
	local land = Items(IMAGES.st_landscape, IMAGES["stairRoom"], 26, 22, "landscape")
	local head = Items(IMAGES.st_head, IMAGES["stairRoom"], 80, 22, "head")
	--hallway left
	local stand = Items(IMAGES.hl_stand, IMAGES["hallwayLeft"], 40, 27, "stand")
	local bench = Items(IMAGES.hl_bench, IMAGES["hallwayLeft"], 74, 34, "bench")
	local ball = Items(IMAGES.hl_ball, IMAGES["hallwayLeft"], 100, 39, "ball")
	--storage room
	local storage = Items(IMAGES.store_cabinet, IMAGES["storageRoom"], 7, 27, "storage")
	local toolbox = Items(IMAGES.store_toolbox, IMAGES["storageRoom"], 76, 38, "toolbox")
	local store_bench = Items(IMAGES.store_bench, IMAGES["storageRoom"], 94, 37, "store_bench")
	local hoop = Items(IMAGES.store_hoop, IMAGES["storageRoom"], 115, 22, "hoop")
	--master room
	local candle_left = Items(IMAGES.mast_candles, IMAGES["masterRoom"], 20, 28, "candles left")
	local candle_right = Items(IMAGES.mast_candles, IMAGES["masterRoom"], 80, 28, "candles right")
	--hallway right
	local abstract = Items(IMAGES.hr_abstract, IMAGES["hallwayRight"], 26, 22, "abstract")
	local surreal = Items(IMAGES.hr_surreal, IMAGES["hallwayRight"], 84, 26, "surreal")
	--daughter room
	local cabinet = Items(IMAGES.dr_cabinet, IMAGES["daughterRoom"], 7, 23, "cabinet")
	local crib = Items(IMAGES.dr_crib, IMAGES["daughterRoom"], 26, 32, "crib")
	local stuffs = Items(IMAGES.dr_stuffs, IMAGES["daughterRoom"], WIDTH / 2 + 23, 28, "toy")
	--kitchen
	local kTable = Items(IMAGES.k_table, IMAGES["kitchen"], 20, 28, "kitchen table")
	local ref = Items(IMAGES.k_ref, IMAGES["kitchen"], 42, 26, "refrigerator")
	local trash = Items(IMAGES.k_trash, IMAGES["kitchen"], 66, 37, "trash bin")
	local sink = Items(IMAGES.k_sink, IMAGES["kitchen"], 74, 20, "sink")
	--secret room
	local bed = Items(IMAGES.bed, IMAGES["secretRoom"], 8, 35, "master bed")
	local vault = Items(IMAGES.vault, IMAGES["secretRoom"], 40, 26, "safe vault")
	--local rope = Items(images.rope,images["secretRoom"],80,20,"rope")
	local tv = Items(IMAGES.tv, IMAGES["secretRoom"], 113, 27, "tv")

	--attic room
	local attic_ladder = Items(IMAGES.attic_room_ladder, IMAGES["atticRoom"], 78, 42, "attic_ladder")
	table.insert(ITEMS_LIST, attic_ladder)
	local attic_clock = Items(IMAGES.clock, IMAGES["atticRoom"], WIDTH / 2 - 12, 22, "clock")
	table.insert(ITEMS_LIST, attic_clock)
	local attic_chest = Items(IMAGES.chest, IMAGES["atticRoom"], 11, 35, "chest")
	table.insert(ITEMS_LIST, attic_chest)

	local storage_puzzle_item = Items(IMAGES.storage_vault, IMAGES["storageRoom"], 40, 30, "storage puzzle")
	table.insert(ITEMS_LIST, storage_puzzle_item)

	if not ON_MOBILE then
		local b_battery = Items(IMAGES.basement_battery, IMAGES["basementRoom"], 30, 38, "battery")
		table.insert(ITEMS_LIST, b_battery)
	end

	table.insert(ITEMS_LIST, bed)
	table.insert(ITEMS_LIST, vault)
	table.insert(ITEMS_LIST, tv)

	table.insert(ITEMS_LIST, storage)
	table.insert(ITEMS_LIST, toolbox)
	table.insert(ITEMS_LIST, store_bench)
	table.insert(ITEMS_LIST, hoop)

	table.insert(ITEMS_LIST, shoerack)
	table.insert(ITEMS_LIST, shelf)

	table.insert(ITEMS_LIST, display)
	table.insert(ITEMS_LIST, portraits)

	table.insert(ITEMS_LIST, head)
	table.insert(ITEMS_LIST, land)

	table.insert(ITEMS_LIST, stand)
	table.insert(ITEMS_LIST, bench)
	table.insert(ITEMS_LIST, ball)

	table.insert(ITEMS_LIST, candle_left)
	table.insert(ITEMS_LIST, candle_right)
	-- table.insert(obj,pl)
	-- table.insert(obj,pr)

	table.insert(ITEMS_LIST, abstract)
	table.insert(ITEMS_LIST, surreal)

	table.insert(ITEMS_LIST, cabinet)
	table.insert(ITEMS_LIST, crib)
	table.insert(ITEMS_LIST, stuffs)

	table.insert(ITEMS_LIST, kTable)
	table.insert(ITEMS_LIST, ref)
	table.insert(ITEMS_LIST, trash)
	table.insert(ITEMS_LIST, sink)

	RL = {
		IMAGES.right_light1,
		IMAGES.right_light2,
		IMAGES.right_light3,
		IMAGES.right_light4,
	}

	LL = {
		IMAGES.left_light1,
		IMAGES.left_light2,
	}

	PUZZLE_PICS = {
		IMAGES.pic1,
		IMAGES.pic2,
		IMAGES.pic3,
		IMAGES.pic4
	}
end

function assets.init_gui_pos()
	local ox, oy = IMAGES.skip:getDimensions()
	ox = (ox / 9) / 2
	oy = oy / 2

	gui_pos = {
		start_x = 4,
		start_y = HEIGHT - 15,
		start_w = IMAGES.start:getWidth(),
		start_h = IMAGES.start:getHeight(),
		quit_x = 6,
		quit_y = HEIGHT - 8,
		quit_w = IMAGES.exit:getWidth(),
		quit_h = IMAGES.exit:getHeight(),
		b_x = 4,
		b_y = HEIGHT - 15,
		b_w = IMAGES.return_gui:getWidth(),
		b_h = IMAGES.return_gui:getHeight(),
		skip_x = WIDTH / 2 - ox,
		skip_y = HEIGHT_HALF - oy,
		skip_w = 8,
		skip_h = 8,
		t_x = WIDTH / 2 - IMAGES.twitter:getWidth() / 2 + 50,
		t_y = 13,
		t_w = IMAGES.twitter:getWidth(),
		t_h = IMAGES.twitter:getHeight(),
		p_x = WIDTH / 2 - IMAGES.paypal:getWidth() / 2 + 50,
		p_y = 29,
		p_w = IMAGES.paypal:getWidth(),
		p_h = IMAGES.paypal:getHeight(),
		e_x = WIDTH / 2 - IMAGES.email:getWidth() / 2 + 50,
		e_y = HEIGHT - 17,
		e_w = IMAGES.email:getWidth(),
		e_h = IMAGES.email:getHeight(),
	}

	local icon_size = 8
	local items = {
		{ "options_", IMAGES.options },
		{ "g_",       IMAGES.gui_gallery },
		{ "q_",       IMAGES.question },
		{ "i_",       IMAGES.instruction_gui },
		{ "a_",       IMAGES.about },
		{ "web",      IMAGES.website_gui }
	}

	local base_x = WIDTH / 2 + icon_size * 1.5
	local base_y = HEIGHT - 13
	local pad = 2
	for i, item in ipairs(items) do
		local id, image = unpack(item)
		gui_pos[id .. "x"] = base_x + icon_size * (i - 2) + pad * (i - 2)
		gui_pos[id .. "y"] = base_y
		gui_pos[id .. "w"] = image:getWidth()
		gui_pos[id .. "h"] = image:getHeight()
	end
end

function assets.dialogue_set()
	local shoerack = Interact(false, { "This is a shoerack", "It's unattended for some time", "Check inside?" },
		{ "Yes", "No" }, "Just Worn Out Shoes", "shoerack")
	--local shelf = Interact(false,{"this is a shelf","Look inside?"},{"Yes","No"},"just full of some items","shelf")
	local shelf = Interact(false, { "this is a shelf", "Look inside?" }, { "Yes", "No" }, "There's nothing more here",
		"shelf")
	local portraits = Interact(false, { "portraits of me and my wife", "her face was blurred out" },
		{ "Touch it", "Leave it" }, "Some parts are rough", "portraits")
	local display = Interact(false, { "just some displays", "nothing special", "There's a glass" },
		{ "Break it", "Leave it be" }, "I must not. It's expensive", "displays")
	local landscape = Interact(false,
		{ "A painting of a landscape", "It's my relaxation", "and my inspiration", "Stare at it?" }, { "Yes",
			"No" }, "It's beautiful", "landscape")
	local head = Interact(false, { "A portrait of an animal head", "it's a lion", "It's quite broken", "Break it?" },
		{ "Yes", "No" }, "Quite fragile, I may be able to break it", "head")
	local stand = Interact(false,
		{ "A coat hanger stand", "I wonder where's the hat", "That goes with it", "Place Hat and coat?" },
		{ "Yes", "No" }, "Where is it?", "stand")
	local bench = Interact(false, { "Just a wooden bench", "Nothing special", "Unless my knees are tired",
		"Sit down?" }, { "Yes", "No" }, "I'm not tired to sit down", "bench")
	local ball = Interact(false, { "A sports ball", "it's quite less bouncy", "Maybe I should pump air", "Pump air?" },
		{ "yes", "no" }, "Where's the air pumper?", "ball")
	local candle_left = Interact(false, { "A row of candle holders", "Light it?" }, { "yes", "no" },
		"It's already lit", "candles left")
	local candle_right = Interact(false, { "A row of candle holders", "Light it?" }, { "yes", "no" },
		"It's already lit", "candles right")

	local abstract = Interact(false, { "An abstract painting", "This is quite bothering", "stare at it?" },
		{ "yes", "no" }, "It creeps me out", "abstract")
	local surreal = Interact(false, { "A surrealistic painting", "It's literally weird", "stare at it?" },
		{ "yes", "no" }, "No one understands it", "surreal")
	local cabinet = Interact(false,
		{ "A cabinet full of clothes", "like gowns, dresses,", "handbags", "jerseys, tank top, slacks",
			"There's a compartment under", "Open it?" }, { "yes", "no" }, "Nothing more here.", "cabinet")
	local crib = Interact(false,
		{ "A child crib", "There are barbie dolls,", "teddy bears,and more stuff toys",
			"There's a small paper with", "drawings in it", "Check it?" }, { "yes", "no" },
		"A child's art I guess.", "crib")
	local stuffs = Interact(false,
		{ "More toys", "Stuff toys,", "Dolls,", "dumbbell", "a hoola hoop hook.", "There's a box.", "Look in it?" },
		{ "Yes", "no" }, "Nothing more here.", "toy")
	local kTable = Interact(false, { "A kitchen table", "Nothing special in it", "Unless one is hungry", "Sit down?" },
		{ "Yes", "No" }, "I have nothing to do", "kitchen table")

	local ref = Interact(false,
		{ "A refrigerator", "there are colorful", "sticky notes and a picture", "of me and my wife with",
			"our child", "What to do?" }, { "Open it", "Look at it" }, "Just foods", "refrigerator")
	local trash = Interact(false, { "A trash bin", "It's full.", "And it smells terrible", "Check inside?" },
		{ "Maybe?", "No way!" }, "There's nothing more here", "trash bin")
	local sink = Interact(false,
		{ "A large apparatus for kitchen", "There are shelves on top,", "Drawers at the bottom",
			"Kitchen stuffs place holders", "And a sink", "Check the drawers?" }, { "Yes", "No" }, "", "sink")
	local storage = Interact(false,
		{ "A large shelf with assorted", "tools, equipments, parts,", "some are still working",
			"others are just junks", "Search through it?" }, { "Yes", "No" }, "Nothing useful here",
		"storage")
	local toolbox = Interact(false, { "A toolbox containing", "nuts, bolts, nails,", "and more", "Search inside?" },
		{ "Yes", "No" }, "nothing useful here", "toolbox")
	local store_bench = Interact(false, { "A steel bench", "its rusty", "Sit?" }, { "I am tired", "No" },
		"I shouldn't", "store_bench")
	local hoop = Interact(false, { "A basketball hoop", "But the net is tied up.", "Put a ball in it?" },
		{ "Yes", "no" }, "Where's the ball?", "hoop")

	local bed = Interact(false, { "It's our bed", "It looks like it has been used", "Check under it" }, { "Yes", "No" },
		"", "master bed")
	local vault = Interact(false, { "It's a picture frame", "I remember something behind it", "Take it off?" },
		{ "Yes", "No" }, "It's too hard", "safe vault")
	local rope = Interact(false, { "It's a rope", "It leads to the attic", "Pull it?" }, { "Yes", "Later" },
		"A ladder fell", "rope")
	local tv = Interact(false, { "it's a television", "some Shows are good", "turn it on?" }, { "Yes", "no" },
		"There's no electricity", "tv")
	local open_vault = Interact(false,
		{ "there's a note inside", "it reads", "Regularly check the ", "attic and b---",
			"The letters are smudged", "There's a tiny lever", "pull it?" }, { "yes", "no" }, "",
		"open_vault")

	local attic_dial = Interact(false, { "it leads to our room", "go down?" }, { "Yes", "No" }, "", "attic_ladder")
	table.insert(DIALOGUES, attic_dial)
	local chest = Interact(false,
		{ "It's a chest containing unused", "stuffs and clothes", "cobwebs and dust all over", "Open it?" },
		{ "Yes", "No" }, "There's nothing more here", "chest")
	table.insert(DIALOGUES, chest)
	local clock = Interact(false,
		{ "It's Granpa's old clock..", "I remember it's not working..", "when Grandpa died last autumn",
			"It's working now..", "Something's not right..", "Open it?" }, { "Yes", "No" },
		"There's nothing more here", "clock")
	table.insert(DIALOGUES, clock)

	local storage_puzzle = Interact(false,
		{ "It's a safe vault", "I need a combination", "to open it.", "Input combination?" }, { "Yes", "No" },
		"There's nothing more here", "storage puzzle")
	table.insert(DIALOGUES, storage_puzzle)
	if not ON_MOBILE then
		local b_battery_dial = Interact(false,
			{ "It's a toolbox", "It contains electronic parts", "Search for items?" }, { "Yes", "No" }, "",
			"battery")
		table.insert(DIALOGUES, b_battery_dial)
	end

	table.insert(DIALOGUES, bed)
	table.insert(DIALOGUES, vault)
	table.insert(DIALOGUES, rope)
	table.insert(DIALOGUES, tv)
	table.insert(DIALOGUES, open_vault)


	table.insert(DIALOGUES, storage)
	table.insert(DIALOGUES, toolbox)
	table.insert(DIALOGUES, store_bench)
	table.insert(DIALOGUES, hoop)

	local holes = Interact(false, { "The holes look like slashes", "There's a box", "Open it?" }, { "Open",
		"Leave it" }, "It's locked", "hole")
	table.insert(DIALOGUES, holes)
	local hoop_ball = Interact(false, { "the ball is inside the hoop", "take the ball again?" }, { "yes", "no" },
		"It's stucked", "hoop_ball")
	table.insert(DIALOGUES, hoop_ball)
	table.insert(DIALOGUES, shoerack)
	table.insert(DIALOGUES, shelf)
	table.insert(DIALOGUES, portraits)
	table.insert(DIALOGUES, display)
	table.insert(DIALOGUES, landscape)
	table.insert(DIALOGUES, head)
	table.insert(DIALOGUES, stand)
	table.insert(DIALOGUES, bench)
	table.insert(DIALOGUES, ball)
	table.insert(DIALOGUES, candle_left)
	table.insert(DIALOGUES, candle_right)
	-- table.insert(dialogue,pl)
	-- table.insert(dialogue,pr)
	table.insert(DIALOGUES, abstract)
	table.insert(DIALOGUES, surreal)
	table.insert(DIALOGUES, cabinet)
	table.insert(DIALOGUES, crib)
	table.insert(DIALOGUES, stuffs)
	table.insert(DIALOGUES, kTable)
	table.insert(DIALOGUES, ref)
	table.insert(DIALOGUES, trash)
	table.insert(DIALOGUES, sink)
end

function assets.find_unused()
	local all = {}

	local fs = love.filesystem.getDirectoryItems("assets")
	for _, f in ipairs(fs) do
		local data = love.filesystem.getInfo("assets/" .. f)
		if data.type == "file" then
			all["assets/" .. f] = 1
		elseif data.type == "directory" then
			for _, f2 in ipairs(love.filesystem.getDirectoryItems("assets/" .. f)) do
				all["assets/" .. f .. "/" .. f2] = 1
			end
		end
	end

	print("UNUSED ASSETS:")
	for _, v in pairs(textures) do
		for _, data in ipairs(v) do
			local name = data[2]
			if all[name] then
				all[name] = all[name] + 1
			end
		end
	end
	for _, v in pairs(sources) do
		for _, data in ipairs(v) do
			local name = data[2]
			if all[name] then
				all[name] = all[name] + 1
			end
		end
	end

	for k, v in pairs(all) do
		if v == 1 then
			print(k)
		end
	end

	error("find_unused is done. do not include this in release")
end

-- assets.find_unused()

return assets
