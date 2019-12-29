* = * "PLAYER CODE"
PLAYER: {
	.label COLLISION_SOLID = %00010000
	.label COLLISION_COLORABLE = %00100000

	.label STATE_JUMP 		= %00000001
	.label STATE_FALL 		= %00000010
	.label STATE_WALK_LEFT  = %00000100
	.label STATE_WALK_RIGHT = %00001000
	.label STATE_FACE_LEFT  = %00010000
	.label STATE_FACE_RIGHT = %00100000
	.label STATE_THROWING 	= %01000000
	.label STATE_EATING 	= %10000000

	.label PLAYER_1 = %00000001
	.label PLAYER_2 = %00000010

	.label JOY_UP = %00001
	.label JOY_DN = %00010
	.label JOY_LT = %00100
	.label JOY_RT = %01000
	.label JOY_FR = %10000

	.label LEFT_SCREEN_EDGE = $14 //MSB = 0
	.label RIGHT_SCREEN_EDGE = $44 //MSB = 1

	.label PLAYER_RIGHT_COLLISON_BOX = 19
	.label PLAYER_LEFT_COLLISON_BOX = 5
	.label FOOT_COLLISION_OFFSET = 3

	.label FIRE_HELD_THRESHOLD = 15

	PlayersActive:
			.byte $00
* =* "Crown"
	PlayerHasCrown:
			.byte $01

	Player1_X:
			// Fractional / LSB / MSB   
			.byte $00, $48, $00 // 1/256th pixel accuracy
	Player2_X:
			// Fractional / LSB / MSB
			.byte $00, $48, $00 // 1/256th pixel accuracy

	Player1_Y:
			.byte $70 // 1 pixel accuracy
	Player2_Y:
			.byte $70 // 1 pixel accuracy


	Player1_FirePressed:
			.byte $00
	Player2_FirePressed:
			.byte $00
	Player1_FireHeld:
			.byte $00
	Player2_FireHeld:
			.byte $00

	Player1_FloorCollision:
			.byte $00
	Player2_FloorCollision:
			.byte $00

	Player1_RightCollision:
			.byte $00
	Player2_RightCollision:
			.byte $00

	Player1_LeftCollision:
			.byte $00
	Player2_LeftCollision:
			.byte $00


	Player1_JumpIndex:
			.byte $00
	Player2_JumpIndex:
			.byte $00

	Player1_WalkIndex:
			.byte $00
	Player2_WalkIndex:
			.byte $00

	Player1_EatIndex:
			.byte $00
	Player2_EatIndex:
			.byte $00

	Player1_ThrowIndex:
			.byte $00
	Player2_ThrowIndex:
			.byte $00

	Player1_State:
			.byte $00
	Player2_State:
			.byte $00

	Player1_WalkSpeed:
			.byte $80, $01
	Player2_WalkSpeed:
			.byte $80, $01

* = * "EAT COUNTERS"
	Player1_EatCount:
			.byte $00
	Player2_EatCount:
			.byte $00
	DefaultFrame:
			.byte $40, $40



	Initialise: {
			lda #$0a
			sta VIC.SPRITE_MULTICOLOR_1
			lda #$06
			sta VIC.SPRITE_MULTICOLOR_2

			lda #$08
			sta VIC.SPRITE_COLOR_5

			lda #$05
			sta VIC.SPRITE_COLOR_6

			lda #$02
			sta VIC.SPRITE_COLOR_7

			lda #$40
			sta SPRITE_POINTERS + 6
			sta SPRITE_POINTERS + 7





			lda #[PLAYER_1 + PLAYER_2]
			sta PlayersActive

			lda #STATE_FACE_RIGHT
			sta Player1_State
			sta Player2_State
			rts
	}


	GetCollisions: {

		//Get floor collisions for each foot for Player 1
		lda #$00
		ldx #PLAYER_LEFT_COLLISON_BOX + FOOT_COLLISION_OFFSET
		ldy #20
		jsr PLAYER.GetCollisionPoint

		jsr UTILS.GetCharacterAt
		tax
		lda CHAR_COLORS, x
		sta Player1_FloorCollision

		
		lda #$00
		ldx #PLAYER_RIGHT_COLLISON_BOX - FOOT_COLLISION_OFFSET
		ldy #20
		jsr PLAYER.GetCollisionPoint

		jsr UTILS.GetCharacterAt
		tax
		lda CHAR_COLORS, x
		ora Player1_FloorCollision
		sta Player1_FloorCollision




		//Get Left Collision
		lda #$00
		sta Player1_LeftCollision
		lda Player1_State
		and #STATE_FACE_LEFT
		beq !Skip+

		lda #$00
		ldx #PLAYER_LEFT_COLLISON_BOX
		ldy #11
		jsr PLAYER.GetCollisionPoint
		jsr UTILS.GetCharacterAt
		tax
		lda CHAR_COLORS, x
		sta Player1_LeftCollision

		lda #$00
		ldx #PLAYER_LEFT_COLLISON_BOX
		ldy #18
		jsr PLAYER.GetCollisionPoint
		jsr UTILS.GetCharacterAt
		tax
		lda CHAR_COLORS, x
		ora Player1_LeftCollision
		sta Player1_LeftCollision
	!Skip:

		//Get Right Collision
		lda #$00
		sta Player1_RightCollision
		lda Player1_State
		and #STATE_FACE_RIGHT
		beq !Skip+

		lda #$00
		ldx #PLAYER_RIGHT_COLLISON_BOX
		ldy #11
		jsr PLAYER.GetCollisionPoint
		jsr UTILS.GetCharacterAt
		tax
		lda CHAR_COLORS, x
		sta Player1_RightCollision

		lda #$00
		ldx #PLAYER_RIGHT_COLLISON_BOX
		ldy #18
		jsr PLAYER.GetCollisionPoint
		jsr UTILS.GetCharacterAt
		tax
		lda CHAR_COLORS, x
		ora Player1_RightCollision
		sta Player1_RightCollision
	!Skip:





		//Get floor collisions for each foot player 2
		lda #$01
		ldx #PLAYER_LEFT_COLLISON_BOX + FOOT_COLLISION_OFFSET
		ldy #20
		jsr PLAYER.GetCollisionPoint

		

		jsr UTILS.GetCharacterAt
		tax
		lda CHAR_COLORS, x
		sta Player2_FloorCollision

		
		lda #$01
		ldx #PLAYER_RIGHT_COLLISON_BOX - FOOT_COLLISION_OFFSET
		ldy #20
		jsr PLAYER.GetCollisionPoint

		jsr UTILS.GetCharacterAt
		tax
		lda CHAR_COLORS, x
		ora Player2_FloorCollision
		sta Player2_FloorCollision


		//Get Left Collision
		lda #$00
		sta Player2_LeftCollision
		lda Player2_State
		and #STATE_FACE_LEFT
		beq !Skip+

		lda #$01
		ldx #PLAYER_LEFT_COLLISON_BOX
		ldy #11
		jsr PLAYER.GetCollisionPoint
		jsr UTILS.GetCharacterAt
		tax
		lda CHAR_COLORS, x
		sta Player2_LeftCollision

		lda #$01
		ldx #PLAYER_LEFT_COLLISON_BOX
		ldy #18
		jsr PLAYER.GetCollisionPoint
		jsr UTILS.GetCharacterAt
		tax
		lda CHAR_COLORS, x
		ora Player2_LeftCollision
		sta Player2_LeftCollision
	!Skip:


		//Get Right Collision
		lda #$00
		sta Player2_RightCollision
		lda Player2_State
		and #STATE_FACE_RIGHT
		beq !Skip+

		lda #$01
		ldx #PLAYER_RIGHT_COLLISON_BOX
		ldy #11
		jsr PLAYER.GetCollisionPoint
		jsr UTILS.GetCharacterAt
		tax
		lda CHAR_COLORS, x
		sta Player2_RightCollision

		lda #$01
		ldx #PLAYER_RIGHT_COLLISON_BOX
		ldy #18
		jsr PLAYER.GetCollisionPoint
		jsr UTILS.GetCharacterAt
		tax
		lda CHAR_COLORS, x
		ora Player2_RightCollision
		sta Player2_RightCollision
	!Skip:

		rts
	}



	GetCollisionPoint: {
			//x register contains x offset (half value)
			//y register contains y offset

			.label PLAYER_POSITION = TEMP1
			.label X_PIXEL_OFFSET = TEMP3
			.label Y_PIXEL_OFFSET = TEMP4

			.label X_BORDER_OFFSET = $18
			.label Y_BORDER_OFFSET = $32

			.label PLAYER_X = VECTOR1
			.label PLAYER_Y = VECTOR2


			stx X_PIXEL_OFFSET
			sty Y_PIXEL_OFFSET

			cmp #$00 //Is player one?
			bne !Player2Setup+

		!Player1Setup:
			lda #<Player1_X
			sta PLAYER_X
			lda #>Player1_X
			sta PLAYER_X + 1
			lda #<Player1_Y
			sta PLAYER_Y
			lda #>Player1_Y
			sta PLAYER_Y + 1
			jmp !PlayerSetupComplete+

		!Player2Setup:
			lda #<Player2_X
			sta PLAYER_X
			lda #>Player2_X
			sta PLAYER_X + 1
			lda #<Player2_Y
			sta PLAYER_Y
			lda #>Player2_Y
			sta PLAYER_Y + 1

		!PlayerSetupComplete:

			//Store Player position X
			ldy #$01
			lda (PLAYER_X), y
			sta PLAYER_POSITION
			iny
			lda (PLAYER_X), y
			sta PLAYER_POSITION + 1
		
			//Add sprite offset X
			lda PLAYER_POSITION
			clc
			adc X_PIXEL_OFFSET
			sta PLAYER_POSITION
			lda PLAYER_POSITION + 1
			adc #$00
			sta PLAYER_POSITION + 1

			//Subtract border width
			lda PLAYER_POSITION
			sec
			sbc #X_BORDER_OFFSET
			sta PLAYER_POSITION
			lda PLAYER_POSITION + 1
			sbc #$00
			sta PLAYER_POSITION + 1

			
			//Divide by 8 to get ScreenX
			lda PLAYER_POSITION
			lsr PLAYER_POSITION + 1
			ror 
			lsr
			lsr
			tax


			//Divide player Y by 8 to get ScreenY
			ldy #$00
			lda (PLAYER_Y), y
			clc
			adc Y_PIXEL_OFFSET
			sec
			sbc #Y_BORDER_OFFSET
			lsr
			lsr
			lsr
			tay

			cpy #$16
			bcc !+
			ldy #$15
		!:
			rts
	}





	DrawPlayer: {

		.label PlayerState = VECTOR1
		.label PlayerWalkIndex = VECTOR2
		.label PlayerX = VECTOR3
		.label PlayerY = VECTOR4

		.label CURRENT_PLAYER = TEMP2
		.label CURRENT_FRAME = TEMP3
		.label TEMP = TEMP4

		//Crown sprite
		lda PlayerHasCrown	
		beq !NoCrown+
	!Crown:
		lda $d015
		ora #%00100000
		sta $d015
		lda PlayerHasCrown
		tay
		dey
		lda Player1_State, y
		and #[STATE_FACE_LEFT]
		bne !FaceLeft+
	!FaceRight:
		lda #$47
		jmp !ApplyCrown+
	!FaceLeft:
		lda #$46
	!ApplyCrown:
		sta SPRITE_POINTERS + 5
		bne !DoneCrown+ //Always taken
	!NoCrown:
		lda $d015
		and #%11011111
		sta $d015
	!DoneCrown:


		lda #$02
		sta CURRENT_PLAYER

		!Loop:
			lda CURRENT_PLAYER
			cmp #$01
			bne !Player2+

		!Player1:
			lda #<Player1_State
			sta PlayerState
			lda #>Player1_State
			sta PlayerState + 1

			lda #<Player1_WalkIndex
			sta PlayerWalkIndex
			lda #>Player1_WalkIndex
			sta PlayerWalkIndex + 1

			lda #<Player1_X
			sta PlayerX
			lda #>Player1_X
			sta PlayerX + 1

			lda #<Player1_Y
			sta PlayerY
			lda #>Player1_Y
			sta PlayerY + 1

			jmp !PlayerSetupComplete+

		!Player2:
			lda #<Player2_State
			sta PlayerState
			lda #>Player2_State
			sta PlayerState + 1

			lda #<Player2_WalkIndex
			sta PlayerWalkIndex
			lda #>Player2_WalkIndex
			sta PlayerWalkIndex + 1

			lda #<Player2_X
			sta PlayerX
			lda #>Player2_X
			sta PlayerX + 1

			lda #<Player2_Y
			sta PlayerY
			lda #>Player2_Y
			sta PlayerY + 1

		!PlayerSetupComplete:

			//Set player frame
				ldx CURRENT_PLAYER
				dex
				lda DefaultFrame, x   //Default idle frame
				sta CURRENT_FRAME

				ldy #$00 //Set IZPY index
			!AreWeThrowing:
				//Are we throwing?
				lda (PlayerState), y
				and #[STATE_THROWING]
				beq !NotThrowing+
				//Yes we are throwing!!
				//Grab next throw frame
				stx TEMP
				lda Player1_ThrowIndex, x
				tax
				lda (PlayerState), y
				and #[STATE_FACE_LEFT]
				beq !+
				lda TABLES.PlayerThrowLeft, x
				jmp !SkipFaceCheck+
			!:
				lda TABLES.PlayerThrowRight, x
			!SkipFaceCheck:
				sta CURRENT_FRAME	
				ldx TEMP

				//Increment Counter and turn of state if needed
				lda Player1_ThrowIndex , x
				clc
				adc #$01
				sta Player1_ThrowIndex , x
				cmp #[TABLES.__PlayerThrowLeft - TABLES.PlayerThrowLeft]
				bne !+
				lda (PlayerState), y
				and #[255 - STATE_THROWING]
				sta (PlayerState), y
			
			!:
				lda Player1_ThrowIndex , x
				cmp #$03
				bne !+
				//X is available index
				cpx #$00
				bne !CheckPlayer2+
			!CheckPlayer1:
				jsr PROJECTILES.CheckPlayer1CanShoot
				bpl !CheckComplete+
			!CheckPlayer2:
				jsr PROJECTILES.CheckPlayer2CanShoot
			!CheckComplete:
				lda TEMP //Player 1 = 00
				ldy #$01 //Projectile Type
				jsr PROJECTILES.SpawnProjectile
			!:
				jmp !SetFrame+


			!NotThrowing:
				ldx CURRENT_PLAYER	
				dex
				ldy #$00
				lda (PlayerState), y
				bit TABLES.Plus + STATE_EATING
				beq !NotEating+

				lda Player1_EatIndex, x
				tay
				lda ZP_COUNTER
				and #$03
				bne !Skip+
				iny
				cpy #$02
				bcc !+
				ldy #$02
			!:
				tya
				sta Player1_EatIndex, x
			!Skip:	
				ldy #$00
				lda (PlayerState), y 

				and #[STATE_FACE_LEFT]
				beq !FaceRight+
			!FaceLeft:
				ldy Player1_EatIndex, x
				lda TABLES.PlayerEatLeft, y
				jmp !EatFrame+
			!FaceRight:
				ldy Player1_EatIndex, x
				lda TABLES.PlayerEatRight, y
			!EatFrame:
				sta CURRENT_FRAME 
				jmp !SetFrame+


			!NotEating:
				and #[STATE_WALK_RIGHT + STATE_WALK_LEFT]
				beq !SetFrame+ //If not just do default frame


				lda (PlayerState), y
				and #[STATE_JUMP + STATE_FALL]
				bne !SetFrame+

				lda (PlayerWalkIndex), y
				tax
				lda ZP_COUNTER
				and #$03
				bne !Skip+
				inx
				cpx #[TABLES.__PlayerWalkLeft - TABLES.PlayerWalkLeft]
				bne !+
				ldx #$00
			!:
				txa 
				sta (PlayerWalkIndex), y
			!Skip:


				lda (PlayerState), y
				and #[STATE_WALK_RIGHT]	
				bne !Right+
			!Left:
				lda TABLES.PlayerWalkLeft, x
				sta CURRENT_FRAME

				jmp !SetFrame+

			!Right:
				lda TABLES.PlayerWalkRight, x
				sta CURRENT_FRAME

			!SetFrame:
				lda CURRENT_FRAME
				ldx CURRENT_PLAYER
				sta [SPRITE_POINTERS + 5], x

				//Set player position X & Y
				ldy #$01

				dex
				txa //Convert to sprite X,Y offsets
				asl
				tax

				lda (PlayerX), y
				sta VIC.SPRITE_6_X, x 
				lda PlayerHasCrown
				cmp CURRENT_PLAYER
				bne !Skip+
				lda (PlayerX), y
				sta VIC.SPRITE_5_X, x 
			!Skip:
				iny

				txa
				pha

				ldx CURRENT_PLAYER
				inx
				inx
				inx
				inx
				inx

				lda (PlayerX), y
				beq !+

				lda VIC.SPRITE_MSB
				ora TABLES.PowerOfTwo, x
				jmp !EndMSB+
			!:
				lda VIC.SPRITE_MSB
				and TABLES.InvPowerOfTwo, x

			!EndMSB:
				sta VIC.SPRITE_MSB


				pla
				tax
				ldy #$00
				lda (PlayerY), y
				sta VIC.SPRITE_6_Y, x
				lda PlayerHasCrown
				cmp CURRENT_PLAYER
				bne !Skip+
				lda (PlayerY), y
				sta VIC.SPRITE_5_Y, x 
			!Skip:

		!SkipFrameSet:
			dec CURRENT_PLAYER
			beq !+
			jmp !Loop-
		!:

			rts
	}





	PlayerControl: {
		ldy #$00
		jsr PlayerControlFunc
		ldy #$01
		jsr PlayerControlFunc
		rts
	}

	PlayerControlFunc: {
			.label JOY_PORT_2 = $dc00
			lda JOY_PORT_2, y
			sta JOY_ZP1, y

			lda Player1_State, y	
			and #[255 - STATE_WALK_RIGHT - STATE_WALK_LEFT]
			sta Player1_State, y


		!Fire:
			lda JOY_ZP1, y
			and #JOY_FR
			bne !FirePressed+
			lda #$01
			sta Player1_FirePressed, y
			ldx Player1_FireHeld, y
			inx
			txa
			sta Player1_FireHeld, y
			cpx #FIRE_HELD_THRESHOLD
			bcs !StartEat+
			jmp !+

		!StartEat:
			lda Player1_State, y
			ora #STATE_EATING
			sta Player1_State, y
			jmp !+

		!FirePressed:
			lda Player1_State, y
			bit TABLES.Plus + STATE_EATING
			beq !Skip+
			and #[255 - STATE_EATING]
			sta Player1_State, y
			lda #$00
			sta Player1_FireHeld, y
			sta Player1_FirePressed, y				
			sta Player1_EatIndex, y
			jmp !+

		!Skip:
			lda #$00
			sta Player1_FireHeld, y
			and #STATE_THROWING
			bne !+
			lda Player1_FirePressed, y
			beq !+
			lda #$00
			sta Player1_FirePressed, y	

			cpy #$00
			bne !Plyr2+
		!Plyr1:
			jsr PROJECTILES.CheckPlayer1CanShoot
			jmp !PlyrDone+
		!Plyr2:
			jsr PROJECTILES.CheckPlayer2CanShoot
		!PlyrDone:
			bmi !+ //If negative player cannot shoot


			lda Player1_State, y
			ora #STATE_THROWING
			sta Player1_State, y
			lda #$00
			sta Player1_ThrowIndex, y	
			///
		!:



		!Up:
			lda Player1_State, y
			bit TABLES.Plus + STATE_EATING
			beq !+
			jmp !SkipMovement+
		!:

			lda Player1_State, y
			and #[STATE_FALL + STATE_JUMP]
			bne !+
			lda JOY_ZP1, y
			and #JOY_UP
			bne !+
			lda Player1_State, y
			ora #STATE_JUMP
			sta Player1_State, y
			lda #$00
			sta Player1_JumpIndex, y
			jmp !Left+
		!:


		!Left:
			lda JOY_ZP1, y
			and #JOY_LT
			beq !Skip+
			jmp !+
		!Skip:

			lda Player1_LeftCollision, y
			and #COLLISION_SOLID
			bne !+

			cpy #$00
			bne !Plyr2+
		!Plyr1:
			sec
			lda Player1_X
			sbc Player1_WalkSpeed
			sta Player1_X
			lda Player1_X + 1
			sbc Player1_WalkSpeed + 1
			sta Player1_X + 1
			lda Player1_X + 2
			sbc #$00
			sta Player1_X + 2

			//CHeck screen edge
			lda Player1_X + 2
			bne !SkipEdgeCheck+
			lda Player1_X + 1
			cmp #LEFT_SCREEN_EDGE
			bcs !SkipEdgeCheck+
			lda #$00
			sta Player1_X + 0
			lda #LEFT_SCREEN_EDGE
			sta Player1_X + 1
		!SkipEdgeCheck:
			jmp !PlyrDone+

		!Plyr2:
			sec
			lda Player2_X
			sbc Player2_WalkSpeed
			sta Player2_X
			lda Player2_X + 1
			sbc Player2_WalkSpeed + 1
			sta Player2_X + 1
			lda Player2_X + 2
			sbc #$00
			sta Player2_X + 2

			//CHeck screen edge
			lda Player2_X + 2
			bne !SkipEdgeCheck+
			lda Player2_X + 1
			cmp #LEFT_SCREEN_EDGE
			bcs !SkipEdgeCheck+
			lda #$00
			sta Player2_X + 0
			lda #LEFT_SCREEN_EDGE
			sta Player2_X + 1
		!SkipEdgeCheck:
		!PlyrDone:

			lda Player1_State, y
			and #[255 - STATE_FACE_RIGHT - STATE_WALK_RIGHT]
			ora #[STATE_WALK_LEFT + STATE_FACE_LEFT]
			sta Player1_State, y
			lda #67
			sta DefaultFrame, y
			jmp !Right+
		!:



		!Right:
			lda JOY_ZP1, y
			and #JOY_RT
			beq !Skip+
			jmp !+
		!Skip:

			lda Player1_RightCollision, y
			and #COLLISION_SOLID
			bne !+

			cpy #$00
			bne !Plyr2+

		!Plyr1:
			clc
			lda Player1_X
			adc Player1_WalkSpeed
			sta Player1_X
			lda Player1_X + 1
			adc Player1_WalkSpeed + 1
			sta Player1_X + 1
			lda Player1_X + 2
			adc #$00
			sta Player1_X + 2

			//CHeck screen edge xx/$48/$01
			lda Player1_X + 2
			beq !SkipEdgeCheck+
			lda Player1_X + 1
			cmp #RIGHT_SCREEN_EDGE
			bcc !SkipEdgeCheck+
			lda #$00
			sta Player1_X + 0
			lda #RIGHT_SCREEN_EDGE
			sta Player1_X + 1
		!SkipEdgeCheck:
			jmp !PlyrDone+

		!Plyr2:
			clc
			lda Player2_X
			adc Player2_WalkSpeed
			sta Player2_X
			lda Player2_X + 1
			adc Player2_WalkSpeed + 1
			sta Player2_X + 1
			lda Player2_X + 2
			adc #$00
			sta Player2_X + 2

			//CHeck screen edge xx/$48/$01
			lda Player2_X + 2
			beq !SkipEdgeCheck+
			lda Player2_X + 1
			cmp #RIGHT_SCREEN_EDGE
			bcc !SkipEdgeCheck+
			lda #$00
			sta Player2_X + 0
			lda #RIGHT_SCREEN_EDGE
			sta Player2_X + 1
		!SkipEdgeCheck:

		!PlyrDone:

			lda Player1_State, y
			and #[255 - STATE_FACE_LEFT - STATE_WALK_LEFT]
			ora #[STATE_WALK_RIGHT + STATE_FACE_RIGHT]
			sta Player1_State, y

			lda #64
			sta DefaultFrame, y
		!:
		!SkipMovement:

			rts
	}


	JumpAndFall: {
			.label PlayerState = VECTOR1
			.label PlayerFloorCollision = VECTOR2
			.label PlayerJumpIndex = VECTOR3
			.label PlayerY = VECTOR4

			.label CURRENT_PLAYER = TEMP1

		lda #$02
		sta CURRENT_PLAYER

		!Loop:
			lda CURRENT_PLAYER
			cmp #$01
			bne !Player2+
		!Player1:
			lda #<Player1_State
			sta PlayerState
			lda #>Player1_State
			sta PlayerState + 1

			lda #<Player1_FloorCollision
			sta PlayerFloorCollision
			lda #>Player1_FloorCollision
			sta PlayerFloorCollision + 1

			lda #<Player1_JumpIndex
			sta PlayerJumpIndex
			lda #>Player1_JumpIndex
			sta PlayerJumpIndex + 1

			lda #<Player1_Y
			sta PlayerY
			lda #>Player1_Y
			sta PlayerY + 1

			jmp !PlayerSetupComplete+
		!Player2:
			lda #<Player2_State
			sta PlayerState
			lda #>Player2_State
			sta PlayerState + 1

			lda #<Player2_FloorCollision
			sta PlayerFloorCollision
			lda #>Player2_FloorCollision
			sta PlayerFloorCollision + 1

			lda #<Player2_JumpIndex
			sta PlayerJumpIndex
			lda #>Player2_JumpIndex
			sta PlayerJumpIndex + 1

			lda #<Player2_Y
			sta PlayerY
			lda #>Player2_Y
			sta PlayerY + 1

		!PlayerSetupComplete:
		
			ldy #$00
			lda (PlayerState), y
			and #STATE_JUMP
			bne !ExitFallingCheck+

		!FallCheck:
			lda (PlayerFloorCollision),y
			and #COLLISION_SOLID
			bne !NotFalling+

		!Falling:
			lda (PlayerState), y
			and #STATE_FALL
			bne !ExitFallingCheck+
			lda (PlayerState), y
			ora #STATE_FALL
			sta (PlayerState), y
			lda #[TABLES.__JumpAndFallTable - TABLES.JumpAndFallTable - 1]
			sta (PlayerJumpIndex), y
			jmp !ExitFallingCheck+

		!NotFalling:		
			lda (PlayerState), y
			and #STATE_FALL
			beq !+
			lda (PlayerY), y
			sec
			sbc #$06
			and #$f8
			ora #$06
			sta (PlayerY), y
		!:

			lda (PlayerState), y
			and #[255 - STATE_FALL]
			sta (PlayerState), y
		!ExitFallingCheck:




		!ApplyFallOrJump:
			lda (PlayerState), y
			and #STATE_FALL
			beq !Skip+


			lda (PlayerJumpIndex), y
			tax
			lda TABLES.JumpAndFallTable, x
			clc
			adc (PlayerY), y
			sta (PlayerY), y
			dex
			bpl !+
			ldx #$00
		!:	
			txa
			sta (PlayerJumpIndex), y
		!Skip:



			lda (PlayerState), y
			and #STATE_JUMP
			beq !Skip+

			lda (PlayerJumpIndex), y
			tax
			lda (PlayerY), y
			sec
			sbc TABLES.JumpAndFallTable, x
			sta (PlayerY), y
			inx
			cpx #[TABLES.__JumpAndFallTable - TABLES.JumpAndFallTable]
			bne !+
			dex
			lda (PlayerState), y
			and #[255 - STATE_JUMP]
			ora #STATE_FALL
			sta (PlayerState), y
		!:
			txa
			sta (PlayerJumpIndex), y

		!Skip:

			dec CURRENT_PLAYER
			beq !+
			jmp !Loop-
		!:

			rts
	}
}




