package game

import rl "vendor:raylib"
import m "core:math"
import "core:math/rand"
import "core:fmt"

sprite_rect :: rl.Rectangle
spritesheet : rl.Texture
bsod_texture : rl.Texture
sprite_pet_idle := sprite_rect {0, 0, 64, 64}
sprite_pet_talk := sprite_rect {64, 0, 64, 64}
sprite_pet_eat := sprite_rect {128, 0, 64, 64}
sprite_pet_angry := sprite_rect {64, 64, 64, 64}
sprite_pet_angry_talk := sprite_rect {128, 64, 64, 64}
sprite_berry := sprite_rect {0, 64, 64, 64}
sprite_ak47 := sprite_rect {0, 128, 128, 64}
sprite_boom0 := sprite_rect {192, 0, 64, 64}
sprite_boom1 := sprite_rect {256, 0, 64, 64}
sprite_boom2 := sprite_rect {320, 0, 64, 64}
sprite_boom3 := sprite_rect {384, 0, 64, 64}
sprite_glass_shatter := sprite_rect {192, 64, 256, 192}

snd_talk0 : rl.Sound
snd_talk1 : rl.Sound
snd_talk2 : rl.Sound
snd_talk3 : rl.Sound
snd_talk4 : rl.Sound
snd_talk5 : rl.Sound
snd_talk6 : rl.Sound
snd_talk7 : rl.Sound
snd_talk8 : rl.Sound
snd_talk9 : rl.Sound
snd_talk10 : rl.Sound
snd_talk11 : rl.Sound
snd_talk12 : rl.Sound
snd_talk13 : rl.Sound
snd_talk14 : rl.Sound
snd_talk15 : rl.Sound
snd_talk16 : rl.Sound
snd_talk17 : rl.Sound
snd_talk18 : rl.Sound
snd_mtalk0 : rl.Sound
snd_mtalk1 : rl.Sound
snd_mtalk2 : rl.Sound
snd_mtalk3 : rl.Sound
snd_mtalk4 : rl.Sound
snd_mtalk5 : rl.Sound
snd_mtalk6 : rl.Sound
snd_mtalk7 : rl.Sound
snd_mtalk8 : rl.Sound
snd_mtalk9 : rl.Sound
snd_mtalk10 : rl.Sound
snd_mtalk11 : rl.Sound
snd_boom : rl.Sound
snd_gunshot : rl.Sound
snd_num : rl.Sound

model_miroglu : rl.Model

import_sound :: proc(buffer : []u8) -> rl.Sound
{
    wave := rl.LoadWaveFromMemory(".ogg", &buffer[0], i32(len(buffer)))
    snd := rl.LoadSoundFromWave(wave)
    rl.UnloadWave(wave)
    return snd
}

import_assets :: proc()
{
    // spritesheet
    sprite_data := #load("spritesheet.png")
    sprite_image := rl.LoadImageFromMemory(".png", &sprite_data[0], i32(len(sprite_data)))
    spritesheet = rl.LoadTextureFromImage(sprite_image)
    rl.UnloadImage(sprite_image)
    
    bsod_data := #load("bsod.png")
    bsod_image := rl.LoadImageFromMemory(".png", &bsod_data[0], i32(len(bsod_data)))
    bsod_texture = rl.LoadTextureFromImage(bsod_image)
    rl.UnloadImage(bsod_image)

    //audios
    snd_talk0 = import_sound(#load("audio/talk0.ogg"))
    snd_talk1 = import_sound(#load("audio/talk1.ogg"))
    snd_talk2 = import_sound(#load("audio/talk2.ogg"))
    snd_talk3 = import_sound(#load("audio/talk3.ogg"))
    snd_talk4 = import_sound(#load("audio/talk4.ogg"))
    snd_talk5 = import_sound(#load("audio/talk5.ogg"))
    snd_talk6 = import_sound(#load("audio/talk6.ogg"))
    snd_talk7 = import_sound(#load("audio/talk7.ogg"))
    snd_talk8 = import_sound(#load("audio/talk8.ogg"))
    snd_talk9 = import_sound(#load("audio/talk9.ogg"))
    snd_talk10 = import_sound(#load("audio/talk10.ogg"))
    snd_talk11 = import_sound(#load("audio/talk11.ogg"))
    snd_talk12 = import_sound(#load("audio/talk12.ogg"))
    snd_talk13 = import_sound(#load("audio/talk13.ogg"))
    snd_talk14 = import_sound(#load("audio/talk14.ogg"))
    snd_talk15 = import_sound(#load("audio/talk15.ogg"))
    snd_talk16 = import_sound(#load("audio/talk16.ogg"))
    snd_talk17 = import_sound(#load("audio/talk17.ogg"))
    snd_talk18 = import_sound(#load("audio/talk18.ogg"))
    snd_mtalk0 = import_sound(#load("audio/mtalk0.ogg"))
    snd_mtalk1 = import_sound(#load("audio/mtalk1.ogg"))
    snd_mtalk2 = import_sound(#load("audio/mtalk2.ogg"))
    snd_mtalk3 = import_sound(#load("audio/mtalk3.ogg"))
    snd_mtalk4 = import_sound(#load("audio/mtalk4.ogg"))
    snd_mtalk5 = import_sound(#load("audio/mtalk5.ogg"))
    snd_mtalk6 = import_sound(#load("audio/mtalk6.ogg"))
    snd_mtalk7 = import_sound(#load("audio/mtalk7.ogg"))
    snd_mtalk8 = import_sound(#load("audio/mtalk8.ogg"))
    snd_mtalk9 = import_sound(#load("audio/mtalk9.ogg"))
    snd_mtalk10 = import_sound(#load("audio/mtalk10.ogg"))
    snd_mtalk11 = import_sound(#load("audio/mtalk11.ogg"))
    snd_boom = import_sound(#load("audio/boom.ogg"))
    snd_gunshot = import_sound(#load("audio/gunshot.ogg"))
    snd_num = import_sound(#load("audio/numnumnum.ogg"))

    // miroglu
    model_miroglu = rl.LoadModel("res/miroglu.glb")
}

screen_to_world :: proc(screen : rl.Vector2) -> rl.Vector2
{
    return screen * {1920 / f32(screen_x), 1080 / f32(screen_y)}
}

world_to_screen :: proc(world : rl.Vector2) -> rl.Vector2
{
    return world * {f32(screen_x) / 1920, f32(screen_y) / 1080}
}

draw_from_spritesheet :: proc(rect : sprite_rect, pos, size, pivot : rl.Vector2, rot : f32)
{
    dest_rect := rl.Rectangle {pos.x, pos.y, size.x, size.y}
    rl.DrawTexturePro(spritesheet, rect, dest_rect, pivot * {size.x, size.y}, rot, rl.WHITE)
}

PetGeneral :: struct
{
    position : rl.Vector2,
    message : cstring,
    talking : bool,
}

PetIdle :: struct
{
    using general : PetGeneral,
    eating : bool,
    angry : bool,
}

PetShooter :: struct
{
    using general : PetGeneral,
    rifle_pos : rl.Vector2,
    rifle_angle : f32,
    rifle_exists : bool,
}

PetDashing :: struct
{
    using general : PetGeneral,
    target_position : rl.Vector2
}

PetDead :: struct
{
    using general : PetGeneral
}

PetReborn :: struct
{
    using general : PetGeneral,
    bigger_text : bool,
    bsod : bool,
}

PetHesBack :: struct
{
    good_one : PetGeneral,
    bad_one : PetGeneral,
    miroglu_text : cstring,
}

PetBothDead :: struct
{
    miroglu_text : cstring
}

Pet :: union
{
    PetIdle,
    PetShooter,
    PetDashing,
    PetDead,
    PetReborn,
    PetHesBack,
    PetBothDead,
}
pet : Pet
pet_state_timer : f32
pet_last_played_talk := -1

miroglu_awake := false
miroglu_forgave := false

Berry :: struct
{
    position : rl.Vector2,
    eaten : bool,
}
berries : [dynamic]Berry

Bullet :: struct
{
    position, velocity : rl.Vector2
}
bullets : [dynamic]Bullet

Explosion :: struct
{
    startTime : f64,
    position : rl.Vector2,
}
explosions : [dynamic]Explosion

create_explosion :: proc(pos : rl.Vector2)
{
    append(&explosions, Explosion {startTime = rl.GetTime(), position = pos})
    rl.PlaySound(snd_boom)
}

GlassShatter :: struct
{
    position : rl.Vector2
}
shatters : [dynamic]GlassShatter

CircleParticle :: struct
{
    lifetime_remain : f32,
    color : rl.Color,
    position : rl.Vector2,
    velocity : rl.Vector2,
}
particles : [dynamic]CircleParticle

emit_particles :: proc(emit_origin : rl.Vector2, color : rl.Color, count : i32, lifetime : f32, speed : f32)
{
    for i in 0..<count
    {
        init_dpos := rl.Vector2 {rand.float32_uniform(-1, 1), rand.float32_uniform(-1, 1)}
        temp_particle := CircleParticle{
            lifetime_remain = lifetime,
            color = color,
            position = emit_origin + init_dpos,
            velocity = rl.Vector2Normalize(init_dpos) * speed
        }
        append(&particles, temp_particle)
    }
}

game_init :: proc()
{
    pet = PetIdle {
        position = rl.Vector2 {1600, 1040},
        message = "",
        talking = false
    }

    append(&berries, Berry {position = {500, 500}})
    append(&berries, Berry {position = {800, 800}})
    append(&berries, Berry {position = {1200, 400}})
}

game_update :: proc()
{
    mouse_pos := rl.GetMousePosition()

    pet_state_timer += rl.GetFrameTime()

    switch &p in pet
    {
        case PetIdle:
            // start talk seq
            if pet_state_timer < 13
            {
                // I know this is very bad but i dont care
                if pet_state_timer < 1
                {
                    p.talking = false
                }
                else if pet_state_timer < 3
                {
                    p.message = "Hi!"
                    p.talking = true

                    // sound playing
                    if pet_last_played_talk != 0
                    {
                        pet_last_played_talk = 0
                        rl.PlaySound(snd_talk0)
                    }
                }
                else if pet_state_timer < 4
                {
                    p.talking = false
                }
                else if pet_state_timer < 7
                {
                    p.message = "I'm hungry!"
                    p.talking = true

                    // sound playing
                    if pet_last_played_talk != 1
                    {
                        pet_last_played_talk = 1
                        rl.PlaySound(snd_talk1)
                    }
                }
                else if pet_state_timer < 8
                {
                    p.talking = false
                }
                else if pet_state_timer < 12
                {
                    p.message = "Feed me with strawberries!"
                    p.talking = true
                    
                    // sound playing
                    if pet_last_played_talk != 2
                    {
                        pet_last_played_talk = 2
                        rl.PlaySound(snd_talk2)
                    }
                }
                else
                {
                    p.talking = false
                }
            }

            // stop eating
            if pet_state_timer > 18 && p.eating
            {
                p.eating = false
            }

            // ask for more
            if pet_state_timer > 22 && len(berries) == 0
            {
                if pet_state_timer < 25
                {
                    p.message = "I want more!"
                    p.talking = true
                    
                    // sound playing
                    if pet_last_played_talk != 3
                    {
                        pet_last_played_talk = 3
                        rl.PlaySound(snd_talk3)
                    }
                }
                else if pet_state_timer < 27
                {
                    p.talking = false
                }
                else if pet_state_timer < 30
                {
                    p.message = "I said, I want more!"
                    p.talking = true
                    p.angry = true
                    
                    // sound playing
                    if pet_last_played_talk != 4
                    {
                        pet_last_played_talk = 4
                        rl.PlaySound(snd_talk4)
                    }
                }
                else
                {
                    p.talking = false
                    pet = PetShooter{
                        position = p.position,
                        rifle_pos = p.position + {0, -50},
                        rifle_angle = 45,
                        rifle_exists = true,
                    }
                }
            }
        case PetShooter:
            // start shooting
            if rl.Vector2Distance(p.position, p.rifle_pos) < 100
            {
                p.rifle_angle = -rl.Vector2LineAngle(screen_to_world(mouse_pos), p.rifle_pos)
    
                if pet_state_timer > 0.2
                {
                    pet_state_timer = 0
                    bullet_dpos := rl.Vector2Rotate({-1, 0}, p.rifle_angle)
                    append(&bullets, Bullet {p.rifle_pos + bullet_dpos * 128, bullet_dpos * 2048})
                
                    rl.PlaySound(snd_gunshot)
                }
            }

            // getting the gun away
            if pet_state_timer < 5 && rl.IsMouseButtonDown(.LEFT) && rl.Vector2Distance(p.rifle_pos, screen_to_world(mouse_pos)) < 32
            {
                p.rifle_pos = 0.5 * (p.rifle_pos + screen_to_world(mouse_pos))
            }

            // no more gun for you
            if pet_state_timer > 5
            {
                if pet_state_timer < 6
                {
                    p.talking = false
                }
                else if pet_state_timer < 9
                {
                    p.message = "Give me my gun back!"
                    p.talking = true
                    
                    
                    // sound playing
                    if pet_last_played_talk != 5
                    {
                        pet_last_played_talk = 5
                        rl.PlaySound(snd_talk5)
                    }
                }
                else if pet_state_timer < 10
                {
                    p.talking = false
                    p.rifle_exists = false

                    if !rl.IsSoundPlaying(snd_boom)
                    {
                        create_explosion(p.rifle_pos)
                    }
                }
                else if pet_state_timer < 13
                {
                    p.message = "What have you done!"
                    p.talking = true
                    
                    // sound playing
                    if pet_last_played_talk != 6
                    {
                        pet_last_played_talk = 6
                        rl.PlaySound(snd_talk6)
                    }
                }
                else if pet_state_timer < 14
                {
                    p.talking = false
                }
                else if pet_state_timer < 17
                {
                    p.message = "Imma ruin your computer!"
                    p.talking = true
                    
                    // sound playing
                    if pet_last_played_talk != 7
                    {
                        pet_last_played_talk = 7
                        rl.PlaySound(snd_talk7)
                    }
                }
                else
                {
                    p.talking = false

                    pet = PetDashing{
                        position = p.position,
                        target_position = rl.Vector2 {f32(rl.GetRandomValue(0, screen_x)), f32(rl.GetRandomValue(0, screen_y))},
                    }
                }
            }
        case PetDashing:
            if rl.Vector2Distance(p.position, p.target_position) < 32
            {
                create_explosion(p.position)
                p.target_position = rl.Vector2 {f32(rl.GetRandomValue(0, screen_x)), f32(rl.GetRandomValue(0, screen_y))}

                //create glass shatter
                append(&shatters, GlassShatter {position = p.position})
            }
            else
            {
                p.position += rl.Vector2Normalize(p.target_position - p.position) * rl.GetFrameTime() * 2048
            }

            // clicking on kills it
            if rl.IsMouseButtonPressed(.LEFT) && rl.Vector2Distance(p.position, world_to_screen(mouse_pos)) < 64
            {
                create_explosion(p.position)
                emit_particles(p.position, rl.PINK, 45, 3, 64)

                pet = PetDead {}

                pet_state_timer = 0
            }
        case PetDead:
            if !miroglu_forgave && pet_state_timer > 3
            {
                miroglu_awake = true

                if pet_state_timer < 5
                {}
                else if pet_state_timer < 8
                {
                    p.message = "Why? Why did you kill your fluffy pet?"
                    
                    // sound playing
                    if pet_last_played_talk != 8
                    {
                        pet_last_played_talk = 8
                        rl.PlaySound(snd_mtalk0)
                    }
                }
                else if pet_state_timer < 12
                {
                    p.message = "You massacred that poor soul!"
                    
                    // sound playing
                    if pet_last_played_talk != 9
                    {
                        pet_last_played_talk = 9
                        rl.PlaySound(snd_mtalk1)
                    }
                }
                else if pet_state_timer < 15
                {
                    p.message = "He just wanted some strawberries!"
                    
                    // sound playing
                    if pet_last_played_talk != 10
                    {
                        pet_last_played_talk = 10
                        rl.PlaySound(snd_mtalk2)
                    }
                }
                else if pet_state_timer < 18
                {
                    p.message = "You monster!"
                    
                    // sound playing
                    if pet_last_played_talk != 11
                    {
                        pet_last_played_talk = 11
                        rl.PlaySound(snd_mtalk3)
                    }
                }
                else
                {
                    p.message = ""
                    if rl.GuiButton({f32(screen_x) * 0.25, f32(screen_y) * 0.1, f32(screen_x) * 0.5, f32(screen_y) * 0.25}, "IT WAS A MISTAKE")
                    {
                        miroglu_forgave = true
                        pet_state_timer = 0
                    }
                }
            }
            if miroglu_forgave
            {
                if pet_state_timer < 3
                {
                    p.message = "Ok! You are forgiven!"
                    
                    // sound playing
                    if pet_last_played_talk != 12
                    {
                        pet_last_played_talk = 12
                        rl.PlaySound(snd_mtalk4)
                    }
                }
                else if pet_state_timer < 6
                {
                    p.message = "I'm giving you a new fluffy pet!"
                    
                    // sound playing
                    if pet_last_played_talk != 13
                    {
                        pet_last_played_talk = 13
                        rl.PlaySound(snd_mtalk5)
                    }
                }
                else if pet_state_timer < 9
                {
                    p.message = "Take care of him!"
                    
                    // sound playing
                    if pet_last_played_talk != 14
                    {
                        pet_last_played_talk = 14
                        rl.PlaySound(snd_mtalk6)
                    }
                }
                else
                {
                    miroglu_awake = false
                    pet = PetReborn{
                        position = rl.Vector2 {960, 1040}
                    }

                    pet_state_timer = 0
                }
            }
        case PetReborn:
            if pet_state_timer < 2
            {}
            else if pet_state_timer < 4
            {
                p.message = "Hi!"
                p.talking = true

                // sound playing
                if pet_last_played_talk != 0
                {
                    pet_last_played_talk = 0
                    rl.PlaySound(snd_talk0)
                }
            }
            else if pet_state_timer < 5
            {
                p.talking = false
            }
            else if pet_state_timer < 8
            {
                p.message = "I'm hungry!"
                p.talking = true

                // sound playing
                if pet_last_played_talk != 1
                {
                    pet_last_played_talk = 1
                    rl.PlaySound(snd_talk1)
                }
            }
            else if pet_state_timer < 9
            {
                p.talking = false
            }
            else if pet_state_timer < 12
            {
                p.message = "Feed me with strawberries!"
                p.talking = true
                
                // sound playing
                if pet_last_played_talk != 2
                {
                    pet_last_played_talk = 2
                    rl.PlaySound(snd_talk2)
                }
            }
            else if pet_state_timer < 13
            {
                p.talking = false
            }
            else if pet_state_timer < 16
            {
                p.message = "What? No strawberries?"
                p.talking = true
                
                // sound playing
                if pet_last_played_talk != 3
                {
                    pet_last_played_talk = 3
                    rl.PlaySound(snd_talk8)
                }
            }
            else if pet_state_timer < 17
            {
                p.talking = false
            }
            else if pet_state_timer < 19
            {
                p.message = "No worries!"
                p.talking = true
                
                // sound playing
                if pet_last_played_talk != 4
                {
                    pet_last_played_talk = 4
                    rl.PlaySound(snd_talk9)
                }
            }
            else if pet_state_timer < 20
            {
                p.talking = false
            }
            else if pet_state_timer < 25
            {
                p.message = "Maybe the real strawberries were the friends we made along the way!"
                p.talking = true
                
                // sound playing
                if pet_last_played_talk != 5
                {
                    pet_last_played_talk = 5
                    rl.PlaySound(snd_talk10)
                }
            }
            else if pet_state_timer < 26
            {
                p.talking = false
            }
            else if pet_state_timer < 29
            {
                p.message = "Our friendship is worth more than those strawberries!"
                p.talking = true
                
                // sound playing
                if pet_last_played_talk != 6
                {
                    pet_last_played_talk = 6
                    rl.PlaySound(snd_talk11)
                }
            }
            else if pet_state_timer < 30
            {
                p.talking = false
            }
            else if pet_state_timer < 32
            {
                p.message = "And they lived happily ever after..."
                p.bigger_text = true
            }
            else if pet_state_timer < 37
            {
                p.bsod = true
            }
            else
            {
                create_explosion({960, 540})

                pet = PetHesBack{
                    good_one = PetGeneral{
                        position = p.position
                    },
                    bad_one = PetGeneral{
                        position = {960, 540}
                    }
                }

                pet_state_timer = 0

                clear(&shatters)
            }
        case PetHesBack:
            if pet_state_timer < 1
            {}
            else if pet_state_timer < 4
            {
                p.bad_one.message = "Guess who crawled out of the Recycle Bin?"
                p.bad_one.talking = true
                
                // sound playing
                if pet_last_played_talk != 7
                {
                    pet_last_played_talk = 7
                    rl.PlaySound(snd_talk12)
                }
            }
            else if pet_state_timer < 6
            {
                p.good_one.message = "Oh no!"
                p.bad_one.talking = false
                p.good_one.talking = true
                
                // sound playing
                if pet_last_played_talk != 8
                {
                    pet_last_played_talk = 8
                    rl.PlaySound(snd_talk13)
                }
            }
            else if pet_state_timer < 9
            {
                p.bad_one.message = "And now you are cheating on me?"
                p.bad_one.talking = true
                p.good_one.talking = false
                
                // sound playing
                if pet_last_played_talk != 9
                {
                    pet_last_played_talk = 9
                    rl.PlaySound(snd_talk14)
                }
            }
            else if pet_state_timer < 12
            {
                p.bad_one.message = "Imma kill that new pet of yours"
                p.bad_one.talking = true
                p.good_one.talking = false
                
                // sound playing
                if pet_last_played_talk != 10
                {
                    pet_last_played_talk = 10
                    rl.PlaySound(snd_talk15)
                }
            }
            else if pet_state_timer < 15
            {
                p.good_one.message = "Please don't!"
                p.bad_one.talking = false
                p.good_one.talking = true
                
                // sound playing
                if pet_last_played_talk != 11
                {
                    pet_last_played_talk = 11
                    rl.PlaySound(snd_talk16)
                }
            }
            else if pet_state_timer < 16
            {
                p.good_one.talking = false

                lerp_val := pet_state_timer - 15
                p.good_one.position = rl.Vector2Lerp(p.good_one.position, {1280, 1040}, lerp_val)
                p.bad_one.position = rl.Vector2Lerp(p.bad_one.position, {1200, 1040}, lerp_val)
            }
            else if pet_state_timer < 17
            {
                miroglu_awake = true
            }
            else if pet_state_timer < 20
            {
                p.miroglu_text = "Boys! Don't fight!"
                
                // sound playing
                if pet_last_played_talk != 12
                {
                    pet_last_played_talk = 12
                    rl.PlaySound(snd_mtalk7)
                }
            }
            else if pet_state_timer < 22
            {
                p.miroglu_text = ""
                p.bad_one.message = "Or else?"
                p.bad_one.talking = true
                p.good_one.talking = false
                
                // sound playing
                if pet_last_played_talk != 13
                {
                    pet_last_played_talk = 13
                    rl.PlaySound(snd_talk17)
                }
            }
            else if pet_state_timer < 25
            {
                p.miroglu_text = "Or else i'll kill both you!"
                p.bad_one.talking = false
                
                // sound playing
                if pet_last_played_talk != 14
                {
                    pet_last_played_talk = 14
                    rl.PlaySound(snd_mtalk8)
                }
            }
            else if pet_state_timer < 27
            {
                p.miroglu_text = ""
                p.bad_one.message = "I don't care!"
                p.bad_one.talking = true
                p.good_one.talking = false
                
                // sound playing
                if pet_last_played_talk != 15
                {
                    pet_last_played_talk = 15
                    rl.PlaySound(snd_talk18)
                }
            }
            else
            {
                create_explosion(p.good_one.position)
                create_explosion(p.bad_one.position)

                pet = PetBothDead{}

                pet_state_timer = 0
            }
        case PetBothDead:
            if pet_state_timer < 2
            {}
            else if pet_state_timer < 5
            {
                p.miroglu_text = "Now they all gone!"
                
                // sound playing
                if pet_last_played_talk != 9
                {
                    pet_last_played_talk = 9
                    rl.PlaySound(snd_mtalk9)
                }
            }
            else if pet_state_timer < 6
            {
                p.miroglu_text = ""
            }
            else if pet_state_timer < 9
            {
                p.miroglu_text = "Sorry for the troubles"
                
                // sound playing
                if pet_last_played_talk != 10
                {
                    pet_last_played_talk = 10
                    rl.PlaySound(snd_mtalk10)
                }
            }
            else if pet_state_timer < 10
            {
                p.miroglu_text = ""
            }
            else if pet_state_timer < 13
            {
                p.miroglu_text = "Goodbye!"
                
                // sound playing
                if pet_last_played_talk != 11
                {
                    pet_last_played_talk = 11
                    rl.PlaySound(snd_mtalk11)
                }
            }
            else
            {
                rl.CloseWindow()
            }
    }

    for &b in berries
    {
        // dragging strawberries
        if rl.IsMouseButtonDown(.LEFT)
        {
            if rl.Vector2Distance(mouse_pos, world_to_screen(b.position)) < 32
            {
                b.position = (screen_to_world(mouse_pos) + b.position) * 0.5
            }
        }

        #partial switch &p in pet
        {
            case PetIdle:
                // pet eats strawberry
                if rl.Vector2Distance(p.position, b.position) < 64 && !p.eating
                {
                    b.eaten = true
                    p.eating = true
                    pet_state_timer = 15

                    if p.talking
                    {
                        p.message = ""
                        p.talking = false
                    }

                    rl.PlaySound(snd_num)

                    emit_particles(b.position, rl.RED, 15, 2, 64)
                }
        }
    }

    // delete eaten berries
    #reverse for b, i in berries
    {
        if !b.eaten do continue

        unordered_remove(&berries, i)
    }

    for &b in bullets
    {
        dpos := b.velocity * rl.GetFrameTime()
        b.position += dpos

        // bullets knockback the cursor
        if rl.Vector2Distance(b.position, screen_to_world(mouse_pos)) < 32
        {
            rl.SetMousePosition(i32(rl.Clamp(mouse_pos.x + dpos.x * 4, 0, f32(screen_x))), i32(rl.Clamp(mouse_pos.y + dpos.y * 4, 0, f32(screen_y))))
        }
    }

    if len(bullets) > 30
    {
        ordered_remove(&bullets, 0)
    }

    // delete explosions
    #reverse for e, i in explosions
    {
        if rl.GetTime() - e.startTime >= 1
        {
            unordered_remove(&explosions, i)
        }
    }

    for &p in particles
    {
        p.position += p.velocity * rl.GetFrameTime()
        p.lifetime_remain -= rl.GetFrameTime()
    }

    //delete particles
    #reverse for p, i in particles
    {
        if p.lifetime_remain < 0
        {
            unordered_remove(&particles, i)
        }
    }
}

game_draw :: proc()
{
    mouse_pos := rl.GetMousePosition()

    switch p in pet
    {
        case PetIdle:
            pet_sprite := sprite_pet_idle
            if p.angry do pet_sprite = sprite_pet_angry
            if p.talking && m.mod(rl.GetTime(), 0.4) > 0.2
            {
                if p.angry do pet_sprite = sprite_pet_angry_talk
                else do pet_sprite = sprite_pet_talk
            }
            if p.eating && m.mod(rl.GetTime(), 0.4) > 0.2 do pet_sprite = sprite_pet_eat
        
            draw_from_spritesheet(pet_sprite, world_to_screen(p.position), world_to_screen({128, 128}), {0.5, 1}, 0)
        
            if p.talking
            {
                text_width := rl.MeasureText(p.message, 32)
                text_pos := world_to_screen(p.position - {0, 160}) - {f32(text_width / 2), 0}
                rl.DrawText(p.message, i32(text_pos.x), i32(text_pos.y), 32, rl.WHITE)
            }

        case PetShooter:
            pet_sprite := sprite_pet_angry
            if p.talking && m.mod(rl.GetTime(), 0.4) > 0.2 do pet_sprite = sprite_pet_angry_talk
            draw_from_spritesheet(pet_sprite, world_to_screen(p.position), world_to_screen({128, 128}), {0.5, 1}, 0)
            if p.rifle_exists do draw_from_spritesheet(sprite_ak47, world_to_screen(p.rifle_pos), world_to_screen({256, 128}), {.5, .5}, p.rifle_angle * rl.RAD2DEG)
            
            if p.talking
            {
                text_width := rl.MeasureText(p.message, 32)
                text_pos := world_to_screen(p.position - {0, 160}) - {f32(text_width / 2), 0}
                rl.DrawText(p.message, i32(text_pos.x), i32(text_pos.y), 32, rl.WHITE)
            }

        case PetDashing:
            draw_from_spritesheet(sprite_pet_angry, world_to_screen(p.position), world_to_screen({128, 128}), {0.5, 1}, 0)
        case PetDead:
            if p.message != ""
            {
                text_width := rl.MeasureText(p.message, 64)
                text_pos := world_to_screen({960, 80}) - {f32(text_width / 2), 0}
                rl.DrawText(p.message, i32(text_pos.x), i32(text_pos.y), 64, rl.WHITE)
            }
        case PetReborn:
            pet_sprite := sprite_pet_idle
            if p.talking && m.mod(rl.GetTime(), 0.4) > 0.2 do pet_sprite = sprite_pet_talk
        
            draw_from_spritesheet(pet_sprite, world_to_screen(p.position), world_to_screen({128, 128}), {0.5, 1}, 0)
            
            if p.talking
            {
                text_width := rl.MeasureText(p.message, 32)
                text_pos := world_to_screen(p.position - {0, 160}) - {f32(text_width / 2), 0}
                rl.DrawText(p.message, i32(text_pos.x), i32(text_pos.y), 32, rl.WHITE)
            }

            if p.bigger_text
            {
                text_width := rl.MeasureText(p.message, 64)
                text_pos := world_to_screen({960, 540}) - {f32(text_width / 2), 0}
                rl.DrawText(p.message, i32(text_pos.x), i32(text_pos.y), 64, rl.WHITE)
            }
        case PetHesBack:
            // Pet Good one
            pet_sprite := sprite_pet_idle
            if p.good_one.talking && m.mod(rl.GetTime(), 0.4) > 0.2 do pet_sprite = sprite_pet_talk
        
            draw_from_spritesheet(pet_sprite, world_to_screen(p.good_one.position), world_to_screen({128, 128}), {0.5, 1}, 0)
            
            if p.good_one.talking
            {
                text_width := rl.MeasureText(p.good_one.message, 32)
                text_pos := world_to_screen(p.good_one.position - {0, 160}) - {f32(text_width / 2), 0}
                rl.DrawText(p.good_one.message, i32(text_pos.x), i32(text_pos.y), 32, rl.WHITE)
            }
            
            // Pet Bad one
            pet_sprite2 := sprite_pet_angry
            if p.bad_one.talking && m.mod(rl.GetTime(), 0.4) > 0.2 do pet_sprite2 = sprite_pet_angry_talk
        
            draw_from_spritesheet(pet_sprite2, world_to_screen(p.bad_one.position), world_to_screen({128, 128}), {0.5, 1}, 0)
            
            if p.bad_one.talking
            {
                text_width := rl.MeasureText(p.bad_one.message, 32)
                text_pos := world_to_screen(p.bad_one.position - {0, 160}) - {f32(text_width / 2), 0}
                rl.DrawText(p.bad_one.message, i32(text_pos.x), i32(text_pos.y), 32, rl.WHITE)
            }
            
            // miroglu talks
            if p.miroglu_text != ""
            {
                text_width := rl.MeasureText(p.miroglu_text, 64)
                text_pos := world_to_screen({960, 80}) - {f32(text_width / 2), 0}
                rl.DrawText(p.miroglu_text, i32(text_pos.x), i32(text_pos.y), 64, rl.WHITE)
            }
        case PetBothDead:
            if p.miroglu_text != ""
            {
                text_width := rl.MeasureText(p.miroglu_text, 64)
                text_pos := world_to_screen({960, 80}) - {f32(text_width / 2), 0}
                rl.DrawText(p.miroglu_text, i32(text_pos.x), i32(text_pos.y), 64, rl.WHITE)
            }
    }

    for b in berries
    {
        draw_from_spritesheet(sprite_berry, world_to_screen(b.position), world_to_screen({64, 64}), {0.5, 0.5}, 0)
    }

    for b in bullets
    {
        rl.DrawCircleV(b.position, 4, rl.YELLOW)
    }

    for e in explosions
    {
        frame_index := int((rl.GetTime() - e.startTime) * 4)
        if frame_index < 4
        {
            explosion : [4]sprite_rect = {sprite_boom0, sprite_boom1, sprite_boom2, sprite_boom3}
            draw_from_spritesheet(explosion[frame_index], world_to_screen(e.position), world_to_screen({256, 256}), {.5,.5}, 0)
        }
    }

    for s in shatters
    {
        draw_from_spritesheet(sprite_glass_shatter, s.position, world_to_screen({256, 192}), {.5,.5}, 0)
    }

    for p in particles
    {
        psize : f32 = 8.0
        if p.lifetime_remain < 1 do psize = p.lifetime_remain * 8

        rl.DrawCircleV(world_to_screen(p.position), psize, p.color)
    }

    if p, ok := pet.(PetReborn); ok && p.bsod
    {
        rl.DrawTexturePro(bsod_texture, {0, 0, 1920, 1080}, {0, 0, f32(screen_x), f32(screen_y)}, 0, 0, rl.WHITE)
    }
}

screen_x, screen_y : i32
main :: proc()
{
    rl.InitAudioDevice()

    rl.SetConfigFlags({.WINDOW_TRANSPARENT, .WINDOW_UNDECORATED, .WINDOW_TOPMOST})
    rl.InitWindow(320, 320, "virus.exe")

    screen_x = rl.GetMonitorWidth(0)
    screen_y = rl.GetMonitorHeight(0) - 1

    rl.SetWindowPosition(0, 0)
    rl.SetWindowSize(screen_x, screen_y)

    rl.SetTargetFPS(150)

    import_assets()

    game_init()

    cam := rl.Camera {
        position = {-10, 0, 0},
        target = {0, 0, 0},
        up = {0, 1, 0},
        fovy = 90,
        projection = .PERSPECTIVE,
    }

    for !rl.WindowShouldClose()
    {
        game_update()

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLANK)

        rl.BeginMode3D(cam)
        if miroglu_awake do rl.DrawModelEx(model_miroglu, {0, -5, 0}, {0, 1, 0}, f32(rl.GetTime() * 180), {1, 1, 1} * 8, rl.WHITE)
        rl.EndMode3D()

        game_draw()

        rl.EndDrawing()
    }

    rl.CloseWindow()
}