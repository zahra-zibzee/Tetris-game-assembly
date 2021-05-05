
.MODEL small

.STACK 64

.DATA

    my_score             dw   0h
    score_str            db   "SCORE:      $" 
    
    width_length         dw   140h
    height_length        dw   0c8h
    y_start_border       dw   0ah
    x_start_border       dw   96h
    y_end_border         dw   0bfh
    x_end_border         dw   0f1h
    
	blank                db   "              $" 
	starting             db   "Starting...$" 
	end_str              db   "GAME OVER$"
	
	bool_update_block    db   1
	 
    current_type         db   0h
    current_x            dw   0h
    current_y            dw   0h    
    current_color        db   0 
    
    x_start              dw   0h
    y_start              dw   0h
    
    ntimes               dw   0h
                                 
    score_counter        dw   0h


.CODE

main proc far
    
    mov ax, @DATA
    mov ds, ax
    
    ;set graphical mode
    mov ah, 00h
    mov al, 13h
    int 10h
    
    ;set position for starting
    mov ah, 02h
    mov bh, 00h
    mov dh, 05h
    mov dl, 0ch
    int 10h
    
    ;print
    mov ah, 09h
    lea dx, starting
    int 21h
    
    ;wait 1 second  
    mov cx, 0fh
    mov dx, 4240h
    mov ah, 86h
    int 15h
    
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 05h
    mov dl, 0ch
    int 10h
    
    mov ah, 09h
    lea dx, blank
    int 21h 
    
    call show_score
    call show_border
    call show_blocks_around 
    
time_check_label:
    cmp bool_update_block, 1
    jne no_new_block
    call draw_new_block
    jmp new_block
no_new_block:
    call update_block 
new_block:
    
    jmp time_check_label

    ;mov ah, 4ch
    ;int 21h
    ret  
    
main endp   


show_border proc near
    
    mov dx, y_start_border
    mov cx, x_start_border
border_label1:
    mov ah, 0ch
    mov al, 0ch ;light red
    int 10h
    inc cx
    cmp cx, x_end_border
    jle border_label1
    
    cmp dx, y_end_border
    je  out_border1
       
    mov dx, y_end_border
    mov cx, x_start_border
    jmp border_label1  
    
out_border1:    
    mov dx, y_start_border
    mov cx, x_start_border 
    
border_label2:
    mov ah, 0ch
    mov al, 0ch ;light red
    int 10h
    inc dx
    cmp dx, y_end_border
    jle border_label2 
    
    cmp cx, x_end_border
    je out_border2    
    
    mov dx, y_start_border
    mov cx, x_end_border
    jmp border_label2  
    
out_border2:       
    ret
show_border endp

show_blocks_around proc near
    
    mov cx, 96h
    mov dx, 1h
around_label1:
    mov ah, 0ch
    mov al, 7h ;light gray
    int 10h
    inc cx
    mov ax, 0f0h
    cmp cx, ax
    jle around_label1
    
    inc dx
    mov cx, 96h
    cmp dx, 9h
    jle around_label1   

    mov cx, 096h
    mov dx, 0c0h
around_label2:
    mov ah, 0ch
    mov al, 7h ;light gray
    int 10h
    inc cx
    mov ax, 0f0h
    cmp cx, ax
    jle around_label2
    
    inc dx
    mov cx, 96h
    cmp dx, 0c7h
    jl around_label2 
    
    mov cx, 96h
    mov dx, 1h
line_around1:
    mov ah, 0ch
    mov al, 0fh ;white
    int 10h
    inc dx
    cmp dx, 0ah
    jl line_around1
    
    add cx, 9h
    mov dx, 1h
    cmp cx, 0f0h
    jle line_around1   

    mov cx, 96h
    mov dx, 0c0h
line_around2:
    mov ah, 0ch
    mov al, 0fh ;white
    int 10h
    inc dx
    cmp dx, 0c7h
    jl line_around2
    
    add cx, 9h
    mov dx, 0c0h
    cmp cx, 0f0h
    jle line_around2 
    
    mov cx, 8ch
    mov dx, 0ah
around_label3:
    mov ah, 0ch
    mov al, 7h
    int 10h
    inc cx
    cmp cx, 96h
    jl around_label3
    
    mov cx, 8ch
    inc dx
    cmp dx, 0beh
    jl around_label3
    
    mov cx, 0f2h
    mov dx, 0ah
around_label4:
    mov ah, 0ch
    mov al, 7h
    int 10h
    inc cx
    cmp cx, 0fbh
    jle around_label4
    
    mov cx, 0f2h
    inc dx
    cmp dx, 0beh
    jl around_label4
    
    mov cx, 8ch
    mov dx, 0ah
line_around3:
    mov ah, 0ch
    mov al, 0fh
    int 10h
    inc cx
    cmp cx, 96h
    jl line_around3
    
    mov cx, 8ch
    add dx, 9h
    cmp dx, 0beh
    jle line_around3
    
    mov cx, 0f2h
    mov dx, 0ah
line_around4:
    mov ah, 0ch
    mov al, 0fh
    int 10h
    inc cx
    cmp cx, 0fbh
    jle line_around4
    
    mov cx, 0f2h
    add dx, 9h
    cmp dx, 0beh
    jle line_around4
    
       
    ret
show_blocks_around endp

	
draw_new_block proc near
    ;random block
    ;making random number   
    xor dx, dx    
    mov ah, 2ch
    int 21h
    mov ax, dx
    xor dx, dx
    mov cx, 5
    div cx   ;remainder is in dx
    
    mov bool_update_block, 0
    
    cmp dx, 0
    je yellow_block
    
    cmp dx, 1
    je blue_block 
    
    cmp dx, 2
    je pink_block 
    
    cmp dx, 3
    je orange_block
                   
    cmp dx, 4
    je green_block
    
yellow_block:  
    ;is this the end of game?
    mov cx, 0bbh
    mov dx, 0bh
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_game
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_game
    add dx, 9h
    int 10h
    cmp al, 0h
    jne end_game
    sub cx, 9h
    int 10h
    cmp al, 0h
    jne end_game
    
    
    mov current_type, 0
    mov cx, 0bah  ;186
    inc cx 
    mov current_x, cx
    mov dx, 0ah   ;10
    inc dx
    mov current_y, dx
yellow_label:
    mov ah, 0ch
    mov al, 0eh  ;yellow
    int 10h
    inc cx
    cmp cx, 0cch
    jle yellow_label
    
    mov cx, 0bah
    inc cx
    inc dx
    cmp dx, 1ch
    jle  yellow_label
    jmp color_exit
                    
blue_block:  
    ;game end?
    mov cx, 0b2h
    mov dx, 0bh
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_game
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_game
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_game
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_game
     
    mov current_type, 1
    mov cx, 0b1h     ;177
    inc cx 
    mov current_x, cx
    mov dx, 0ah      ;10
    inc dx 
    mov current_y, dx
blue_label:
    mov ah, 0ch
    mov al, 9h ;light blue
    int 10h
    inc cx
    cmp cx, 0d5h     ;213
    jle blue_label
    
    mov cx, 0b1h
    inc cx
    inc dx
    cmp dx, 13h       ;19
    jle blue_label
    jmp color_exit
    
pink_block:  
    ;game end?
    mov cx, 0b2h
    mov dx, 0bh
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_game
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_game
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_game
    add dx, 9h
    sub cx, 9h
    int 10h
    cmp al, 0h
    jne end_game
    
    mov current_type, 2
    mov cx, 0b1h      ;177
    inc cx      
    mov current_x, cx
    mov dx, 0ah       ;10
    inc dx     
    mov current_y, dx
pink_label1:
    mov ah, 0ch
    mov al, 0dh ;pink
    int 10h
    inc cx  
    cmp cx, 0cch
    jle pink_label1
    
    mov cx, 0b1h
    inc cx
    inc dx
    cmp dx, 13h
    jle pink_label1
    
    mov cx, 0bah
    inc cx
    mov dx, 13h
    inc dx
pink_label2:
    mov ah, 0ch
    mov al, 0dh  ;pink
    int 10h
    inc cx
    cmp cx, 0c3h
    jle pink_label2
    
    mov cx, 0bah
    inc cx
    inc dx
    cmp dx, 1ch
    jle pink_label2
    jmp color_exit
     
orange_block: 
    ;game end?
    mov cx, 0bbh
    mov dx, 0bh
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_game
    add dx, 9h
    int 10h
    cmp al, 0h
    jne end_game
    add dx, 9h
    int 10h
    cmp al, 0h
    jne end_game
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_game
     
    mov current_type, 3
    mov cx, 0bah   ;186
    inc cx             
    mov current_x, cx
    mov dx, 0ah    ;10
    inc dx        
    mov current_y, dx
orange_label1:
    mov ah, 0ch
    mov al, 6h ;orange
    int 10h
    inc cx
    cmp cx, 0c3h
    jle orange_label1
    
    mov cx, 0bah
    inc cx
    inc dx
    cmp dx, 25h
    jle orange_label1
    
    mov cx, 0c3h
    inc cx
    mov dx, 1ch
    inc dx
orange_label2:
    mov ah, 0ch
    mov al, 6h    ;orange
    int 10h
    inc cx
    cmp cx, 0cch
    jle orange_label2
    
    mov cx, 0c3h
    inc cx
    inc dx
    cmp dx, 25h
    jle orange_label2
    jmp color_exit
    
green_block:   
    mov cx, 0bbh
    mov dx, 0bh
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_game
    add dx, 9h
    int 10h
    cmp al, 0h
    jne end_game
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_game
    add dx, 9h
    int 10h
    cmp al, 0h
    jne end_game
     
    mov current_type, 4  
    mov cx, 0bah
    inc cx             
    mov current_x, cx
    mov dx, 0ah
    inc dx       
    mov current_y, dx
green_label1:
    mov ah, 0ch
    mov al, 0ah  ;green
    int 10h
    inc cx
    cmp cx, 0c3h
    jle green_label1
    
    mov cx, 0bah
    inc cx
    inc dx
    cmp dx, 1ch
    jle green_label1

    mov cx, 0c3h
    inc cx
    mov dx, 13h
    inc dx
green_label2:
    mov ah, 0ch
    mov al, 0ah  ;green
    int 10h
    inc cx
    cmp cx, 0cch
    jle green_label2
    
    mov cx, 0c3h  
    inc cx
    inc dx
    cmp dx, 25h
    jle green_label2
    jmp color_exit 
    
end_game:
    call game_over
    
color_exit:    
    ret
draw_new_block endp 

game_over proc
    mov ah, 02h
    mov bh, 00h 
    mov dh, 08h
    mov dl, 04h
    int 10h
    
    mov ah, 09h
    lea dx, end_str
    int 21h
    
    mov ah, 4ch
    int 21h
    
    ret
game_over endp

update_block proc near
    
    ;if key has been pressed
    mov ah, 1h
    int 16h
    jz exit_update
    
    mov ah, 0h
    int 16h
    
    ;s key
    cmp al, 73h 
    je call_down_move    
    cmp al, 53h
    je call_down_move
    
    ;a key
    cmp al, 61h
    je call_left_move    
    cmp al, 41h
    je call_left_move
    
    ;d key
    cmp al, 64h
    je call_right_move  
    cmp al, 44h
    je call_right_move
    
    ;w key
    cmp al, 77h
    je call_rotate_move  
    cmp al, 57h
    je call_rotate_move
    
    jmp exit_update
call_rotate_move:
    call rotate_move
    jmp exit_update

call_right_move:
    call right_move
    jmp exit_update
    
call_left_move:
    call left_move
    jmp exit_update
    
call_down_move:
    call down_move
    jmp exit_update
    
exit_update:
    ret
    
update_block endp 

rotate_move proc
    ;yellow has no rotate            
    cmp current_type, 0
    je exit_rotate_move
    
    cmp current_type, 1
    je rotate_move1
    
    cmp current_type, 5
    je rotate_move5 
    
    cmp current_type, 2
    je rotate_move2  
    
    cmp current_type, 6
    je rotate_move6 
    
    cmp current_type, 7
    je rotate_move7 
    
    cmp current_type, 8
    je rotate_move8 
    
    cmp current_type, 3
    je rotate_move3 
    
    cmp current_type, 9
    je rotate_move9  
    
    cmp current_type, 0ah
    je rotate_move10  
    
    cmp current_type, 0bh
    je rotate_move11     
    
    cmp current_type, 4
    je rotate_move4
    
    cmp current_type, 0ch
    je rotate_move12
                      
rotate_move1:
    ;can rotate?
    mov cx, current_x
    mov dx, current_y
    add cx, 9h
    dec dx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    add dx, 0ah
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    
    mov current_color, 0h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 12h     
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 1bh
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
                         
    mov current_color, 9h
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    sub dx, 9h
    mov y_start, dx
    call draw_clear_block 
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block 
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call draw_clear_block 
    
    mov current_type, 5
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    mov dx, current_y
    sub dx, 9h
    mov current_y, dx
    
    ;end?
    mov cx, current_x
    mov dx, current_y
    add dx, 24h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_any_move
    jmp exit_rotate_move 

rotate_move5:
    ;can rotate?
    mov cx, current_x
    mov dx, current_y
    add cx, 9h
    sub dx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    sub cx, 1bh
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    
    mov current_color, 0h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x     
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 1bh
    mov y_start, dx
    call draw_clear_block
                         
    mov current_color, 9h
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call draw_clear_block 
    
    mov cx, current_x
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call draw_clear_block 
    
    mov cx, current_x
    sub cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call draw_clear_block 
    
    mov current_type, 1
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    mov dx, current_y
    add dx, 12h
    mov current_y, dx
    
    ;end?
    mov cx, current_x
    mov dx, current_y
    add dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move
    jmp exit_rotate_move

rotate_move2:
    ;can rotate?
    mov cx, current_x
    mov dx, current_y
    add cx, 9h
    dec dx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    
    mov current_color, 0h
    mov cx, current_x
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
                         
    mov current_color, 0dh
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    sub dx, 9h
    mov y_start, dx
    call draw_clear_block 
    
    mov current_type, 6
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    mov dx, current_y
    sub dx, 9h
    mov current_y, dx
    
    ;end?
    mov cx, current_x
    mov dx, current_y
    add dx, 12h
    sub cx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    add dx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move
    jmp exit_rotate_move
    
rotate_move6:
    ;can rotate?
    mov cx, current_x
    mov dx, current_y
    add cx, 9h
    add dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    
    mov current_color, 0h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call draw_clear_block
                         
    mov current_color, 0dh
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block 
    
    mov current_type, 7
    ;current_x & current_y won't change
    
    ;end?
    mov cx, current_x
    mov dx, current_y
    add dx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move 
    sub cx, 12h
    int 10h
    cmp al, 0h
    jne end_any_move
    jmp exit_rotate_move
    
rotate_move7:
    ;can rotate?
    mov cx, current_x
    mov dx, current_y
    add dx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    
    mov current_color, 0h
    mov cx, current_x 
    sub cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block
                         
    mov current_color, 0dh
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call draw_clear_block 
    
    mov current_type, 8
    ;current_x & current_y won't change
    
    ;end?
    mov cx, current_x
    mov dx, current_y
    add dx, 1bh
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_any_move
    jmp exit_rotate_move 

rotate_move8:
    ;can rotate?
    mov cx, current_x
    mov dx, current_y
    sub cx, 9h
    add dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    
    mov current_color, 0h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
                         
    mov current_color, 0dh
    mov cx, current_x
    sub cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block 
    
    mov current_type, 2
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;end?
    mov cx, current_x
    mov dx, current_y
    add dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    add dx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move 
    add cx, 9h
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move
    jmp exit_rotate_move
    
rotate_move3:
    ;can rotate?
    mov cx, current_x
    mov dx, current_y
    sub cx, 9h
    add dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    sub dx, 9h
    add cx, 12h
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    
    mov current_color, 0h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call draw_clear_block 
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call draw_clear_block
                         
    mov current_color, 6h
    mov cx, current_x
    sub cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    sub cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block 
    
    mov current_type, 9
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;end?
    mov cx, current_x
    mov dx, current_y
    add dx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move 
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move
    jmp exit_rotate_move 
    
rotate_move9:
    ;can rotate?
    mov cx, current_x
    mov dx, current_y
    sub dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    add dx, 12h
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    
    mov current_color, 0h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block 
    
    mov cx, current_x
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
                         
    mov current_color, 6h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    sub dx, 9h
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    sub dx, 9h
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block 
    
    mov current_type, 0ah
    mov dx, current_y
    sub dx, 9h
    mov current_y, dx
    
    ;end?
    mov cx, current_x
    mov dx, current_y
    add dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    add dx, 12h
    int 10h
    cmp al, 0h
    jne end_any_move 
    jmp exit_rotate_move
    
rotate_move10:
    ;can rotate?
    mov cx, current_x
    mov dx, current_y
    add cx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    sub cx, 12h
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    
    mov current_color, 0h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block 
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call draw_clear_block
                         
    mov current_color, 6h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block 
    
    mov current_type, 0bh
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;end?
    mov cx, current_x
    mov dx, current_y
    add dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move
    jmp exit_rotate_move 
    
rotate_move11:  
    ;can rotate?
    mov cx, current_x
    mov dx, current_y
    add cx, 9h
    sub dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    add dx, 12h
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    
    mov current_color, 0h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block 
    
    mov cx, current_x
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    sub dx, 9h
    mov y_start, dx
    call draw_clear_block
                         
    mov current_color, 6h
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    sub dx, 9h
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block 
    
    mov current_type, 3h  
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    mov dx, current_y
    sub dx, 9h
    mov current_y, dx
    
    ;end?
    mov cx, current_x
    mov dx, current_y
    add dx, 1bh
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move
    jmp exit_rotate_move   
    
rotate_move4:
    ;can rotate?
    mov cx, current_x
    mov dx, current_y
    add dx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    sub cx, 9h
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    
    mov current_color, 0h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call draw_clear_block 
                         
    mov current_color, 0ah
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    sub cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call draw_clear_block 
    
    mov current_type, 0ch  
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    mov dx, current_y
    add dx, 12h
    mov current_y, dx
    
    ;end?
    mov cx, current_x
    mov dx, current_y
    add dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move
    jmp exit_rotate_move
    
rotate_move12:
    ;can rotate?
    mov cx, current_x
    mov dx, current_y
    add cx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_rotate_move
    
    mov current_color, 0h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    sub dx, 9h
    mov y_start, dx
    call draw_clear_block 
                         
    mov current_color, 0ah
    mov cx, current_x 
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call draw_clear_block
    
    mov cx, current_x
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call draw_clear_block 
    
    mov current_type, 4h  
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    mov dx, current_y
    sub dx, 9h
    mov current_y, dx
    
    ;end?
    mov cx, current_x
    mov dx, current_y
    add dx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne end_any_move
    add cx, 9h
    add dx, 9h
    int 10h
    cmp al, 0h
    jne end_any_move
    jmp exit_rotate_move  
    
end_any_move: 
    call check_score_update
    mov bool_update_block, 1    
exit_rotate_move:                
    ret
rotate_move endp

draw_clear_block proc
    mov cx, x_start
    mov dx, y_start
    mov ah, 0ch
    mov al, current_color
draw_clear_label:
    int 10h
    inc cx
    mov bx, x_start
    add bx, 8h
    cmp cx, bx
    jle draw_clear_label
    
    mov cx, x_start
    inc dx
    mov bx, y_start
    add bx, 8h
    cmp dx, bx
    jle draw_clear_label
    
    ret
draw_clear_block endp

right_move proc
    cmp current_type, 0
    je right_move0 
    
    cmp current_type, 1
    je right_move1     
    
    cmp current_type, 2
    je right_move2  
    
    cmp current_type, 3
    je right_move3 
    
    cmp current_type, 4
    je right_move4 
    
    cmp current_type, 5
    je right_move5    
    
    cmp current_type, 6
    je right_move6
    
    cmp current_type, 7
    je right_move7
    
    cmp current_type, 8
    je right_move8    
    
    cmp current_type, 9
    je right_move9
    
    cmp current_type, 0ah
    je right_move10
    
    cmp current_type, 0bh
    je right_move11  
    
    cmp current_type, 0ch
    je right_move12
    
right_move0:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add cx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
    
    mov current_color, 0eh
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move 
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 12h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_move_again
    jmp exit_right_move 
    
right_move1:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add cx, 24h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_right_move
    
    mov current_color, 9h
    mov cx, current_x
    add cx, 1bh
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move 
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 9h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_move_again
    jmp exit_right_move 
    
right_move2:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add cx, 1bh
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_right_move
    sub cx, 9h
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
    
    mov current_color, 0dh
    mov cx, current_x
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move 
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 9h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h
    add dx, 9h
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne no_move_again
    jmp exit_right_move  
    
right_move3:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add cx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
    add cx, 9h
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
      
    mov current_color, 6h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call block_right_move 
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 1bh
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_move_again
    jmp exit_right_move   
    
right_move4:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add cx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    add cx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
      
    mov current_color, 0ah
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move 
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 1bh
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h 
    add dx, 9h
    int 10h
    cmp al, 0h
    jne no_move_again
    jmp exit_right_move
    
right_move5:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add cx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
      
    mov current_color, 9h
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call block_right_move 
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 1bh
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 24h
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_move_again
    jmp exit_right_move
    
right_move6:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add cx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
      
    mov current_color, 0dh
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call block_right_move 
    
    mov cx, current_x
    sub cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 12h
    mov cx, current_x
    sub cx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h 
    add dx, 9h
    int 10h
    cmp al, 0h
    jne no_move_again
    jmp exit_right_move
    
right_move7:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add cx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    add cx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
      
    mov current_color, 0dh
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move 
    
    mov cx, current_x
    sub cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 12h
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h 
    int 10h
    cmp al, 0h
    jne no_move_again
    sub cx, 12h
    int 10h
    cmp al, 0h
    jne no_move_again
    jmp exit_right_move

right_move8:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add cx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    add cx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
    sub cx, 9h
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
      
    mov current_color, 0dh
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move 
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 1bh
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h 
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne no_move_again
    jmp exit_right_move
    
right_move9:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add cx, 1bh
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    sub cx, 12h
    int 10h
    cmp al, 0h
    jne exit_right_move
      
    mov current_color, 6h
    mov cx, current_x 
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move 
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 12h
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h 
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne no_move_again 
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_move_again
    jmp exit_right_move
    
right_move10:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add cx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
      
    mov current_color, 6h
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_right_move 
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 9h
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h 
    add dx, 12h
    int 10h
    cmp al, 0h
    jne no_move_again
    jmp exit_right_move
    
right_move11:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add cx, 1bh
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_right_move
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
      
    mov current_color, 6h
    mov cx, current_x  
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x 
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    sub dx, 9h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move 
    
    mov cx, current_x
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 9h
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h 
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_move_again
    jmp exit_right_move
    
right_move12:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add cx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_right_move
    sub dx, 9h
    add cx, 9h
    int 10h
    cmp al, 0h
    jne exit_right_move
      
    mov current_color, 0ah
    mov cx, current_x  
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 12h
    mov x_start, cx
    mov dx, current_y
    sub dx, 9h
    mov y_start, dx
    call block_right_move 
    
    mov cx, current_x
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    sub dx, 9h
    mov y_start, dx
    call block_right_move
    
    mov cx, current_x
    add cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 9h
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_move_again
    add cx, 9h 
    int 10h
    cmp al, 0h
    jne no_move_again
    jmp exit_right_move 
    
no_move_again:  
    call check_score_update
    mov bool_update_block, 1

exit_right_move:    
    ret
right_move endp 

block_right_move proc
    mov ntimes, 9h
main_right_loop:
    mov ah, 0ch 
    mov al, 0h 
    mov cx, x_start
    mov dx, y_start
right_move_label1: 
    int 10h 
    inc dx
    mov bx, y_start
    add bx, 8h
    cmp dx, bx
    jle right_move_label1
              
    mov al, current_color
    mov cx, x_start
    add cx, 9h
    mov dx, y_start 
right_move_label2:
    int 10h    
    inc dx
    mov bx, y_start
    add bx, 8h
    cmp dx, bx
    jle right_move_label2
    
    inc x_start   
    dec ntimes
    cmp ntimes, 0h 
    jg  main_right_loop
    
    ret
block_right_move endp

left_move proc
    cmp current_type, 0
    je left_move0
    
    cmp current_type, 1
    je left_move1 
    
    cmp current_type, 2
    je left_move2
    
    cmp current_type, 3
    je left_move3
                  
    cmp current_type, 4
    je left_move4
    
    cmp current_type, 5
    je left_move5
    
    cmp current_type, 6
    je left_move6
    
    cmp current_type, 7
    je left_move7
    
    cmp current_type, 8
    je left_move8   
    
    cmp current_type, 9
    je left_move9
    
    cmp current_type, 0ah
    je left_move10
    
    cmp current_type, 0bh
    je left_move11  
    
    cmp current_type, 0ch
    je left_move12
left_move0:   
    ;can move?
    mov cx, current_x
    mov dx, current_y
    dec cx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    
    mov current_color, 0eh
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move 
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 12h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_more_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move
    jmp exit_left_move
    
left_move1:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    dec cx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_left_move
    
    mov current_color, 9h
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 1ah
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move 
    
    mov cx, current_x
    add cx, 23h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 9h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_more_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move 
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move
    jmp exit_left_move
    
left_move2:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    dec cx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_left_move
    
    mov current_color, 0dh
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move 
    
    mov cx, current_x
    add cx, 1ah
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 9h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_more_move
    add cx, 9h
    add dx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move 
    add cx, 9h
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move
    jmp exit_left_move

left_move3:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    dec cx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    
    mov current_color, 6h
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call block_left_move 
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    add dx,12h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 1bh 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_more_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move 
    jmp exit_left_move  

left_move4:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    dec cx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    
    mov current_color, 0ah
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move 
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    add dx,12h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 12h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_more_move
    add cx, 9h 
    add dx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move 
    jmp exit_left_move 
    
left_move5:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    dec cx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    
    mov current_color, 9h
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h
    mov y_start, dx
    call block_left_move 
    
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    add dx,1bh
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 24h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_more_move 
    jmp exit_left_move 
    
left_move6:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    dec cx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h 
    sub cx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move  
    add cx, 9h
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    
    mov current_color, 0dh
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    dec cx
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move 
    
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    add dx,12h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 1bh 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_more_move
    sub cx, 9h 
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move 
    jmp exit_left_move 
    
left_move7:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    dec cx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h
    sub cx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    
    mov current_color, 0dh
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    dec cx
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move 
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 12h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_more_move
    add cx, 9h 
    int 10h
    cmp al, 0h
    jne no_more_move
    sub cx, 12h
    int 10h
    cmp al, 0h
    jne no_more_move 
    jmp exit_left_move 
    
left_move8:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    dec cx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    
    mov current_color, 0dh
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move 
    
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    add dx,12h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 1bh 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_more_move
    add cx, 9h 
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move 
    jmp exit_left_move 
    
left_move9:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    dec cx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    
    mov current_color, 6h
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move 
    
    mov cx, current_x
    add cx, 1ah
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 12h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_more_move
    add cx, 9h 
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move 
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move
    jmp exit_left_move 
    
left_move10:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    dec cx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h 
    add cx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    add dx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    
    mov current_color, 6h
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h
    mov y_start, dx
    call block_left_move 
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    add dx,12h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 9h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_more_move
    add cx, 12h 
    add dx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move 
    jmp exit_left_move 
    
left_move11:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    dec cx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_left_move
    sub dx, 9h
    add cx, 12h
    int 10h
    cmp al, 0h
    jne exit_left_move
    
    mov current_color, 6h
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 1ah
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move 
    
    mov cx, current_x
    add cx, 1ah
    mov x_start, cx
    mov dx, current_y
    sub dx, 9h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 9h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_more_move
    add cx, 9h 
    int 10h
    cmp al, 0h
    jne no_more_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_more_move 
    jmp exit_left_move
                       
left_move12:
    ;can move?
    mov cx, current_x
    mov dx, current_y
    dec cx
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne exit_left_move
    sub dx, 9h
    add cx, 9h
    int 10h
    cmp al, 0h
    jne exit_left_move
    
    mov current_color, 0ah
    mov cx, current_x
    add cx, 8h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    add cx, 11h
    mov x_start, cx
    mov dx, current_y
    sub dx, 9h
    mov y_start, dx
    call block_left_move 
    
    mov cx, current_x
    add cx, 1ah
    mov x_start, cx
    mov dx, current_y
    sub dx, 9h
    mov y_start, dx
    call block_left_move
    
    mov cx, current_x
    sub cx, 9h
    mov current_x, cx
    
    ;end?
    mov dx, current_y
    add dx, 9h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_more_move
    add cx, 9h 
    int 10h
    cmp al, 0h
    jne no_more_move
    jmp exit_left_move
no_more_move:    
    call check_score_update
    mov bool_update_block, 1     
exit_left_move:    
    ret
left_move endp 

block_left_move proc
    mov ntimes, 9h
main_left_loop:
    mov ah, 0ch 
    mov al, 0h 
    mov cx, x_start
    mov dx, y_start
left_move_label1: 
    int 10h 
    inc dx
    mov bx, y_start
    add bx, 8h
    cmp dx, bx
    jle left_move_label1
              
    mov al, current_color
    mov cx, x_start
    sub cx, 9h
    mov dx, y_start 
left_move_label2:
    int 10h    
    inc dx
    mov bx, y_start
    add bx, 8h
    cmp dx, bx
    jle left_move_label2
    
    dec x_start   
    dec ntimes
    cmp ntimes, 0h 
    jg  main_left_loop
    
    ret
block_left_move endp
    
down_move proc 
    cmp current_type, 0
    je down_move0 
    
    cmp current_type, 1
    je down_move1
    
    cmp current_type, 2
    je down_move2
    
    cmp current_type, 3
    je down_move3 
    
    cmp current_type, 4
    je down_move4    
    
    cmp current_type, 5
    je down_move5
    
    cmp current_type, 6
    je down_move6
    
    cmp current_type, 7
    je down_move7
    
    cmp current_type, 8
    je down_move8 
    
    cmp current_type, 9
    je down_move9
    
    cmp current_type, 0ah
    je down_move10
    
    cmp current_type, 0bh
    je down_move11     
    
    cmp current_type, 0ch
    je down_move12
    
down_move0:    
    
    mov current_color, 0eh 
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y
    add dx, 9h      
    mov y_start, dx      
    call block_down_move 
     
    mov cx, current_x
    add cx, 9h 
    mov x_start, cx 
    mov dx, current_y
    add dx, 9h      
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x 
    mov x_start, cx 
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    add cx, 9h 
    mov x_start, cx  
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move 
    
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;end?
    mov dx, current_y
    add dx, 12h 
    mov cx, current_x
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_down_move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move
    jmp exit_move 
     
down_move1:  
    
    mov current_color, 9h
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y      
    mov y_start, dx      
    call block_down_move 
     
    mov cx, current_x
    add cx, 9h 
    mov x_start, cx 
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    add cx, 12h 
    mov x_start, cx 
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    add cx, 1bh 
    mov x_start, cx  
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move 
     
    mov dx, current_y
    add dx, 9h
    mov current_y, dx 
    
    ;can move?
    mov cx, current_x
    mov dx, current_y
    add dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move  
    jmp exit_move

down_move2:
    mov current_color, 0dh
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h      
    mov y_start, dx      
    call block_down_move 
     
    mov cx, current_x 
    mov x_start, cx 
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    add cx, 9h
    mov x_start, cx 
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    add cx, 12h 
    mov x_start, cx  
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move 
     
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;can move?
    mov cx, current_x 
    mov dx, current_y
    add dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    add cx, 12h
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    sub cx, 9h  
    add dx, 9h 
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    jmp exit_move 
    
down_move3:
    mov current_color, 6h
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y
    add dx, 12h      
    mov y_start, dx      
    call block_down_move 
     
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx 
    mov dx, current_y 
    add dx, 12h    
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    mov x_start, cx 
    mov dx, current_y  
    add dx, 9h   
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    mov x_start, cx  
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move 
     
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;can move?
    mov cx, current_x 
    mov dx, current_y
    add dx, 1bh
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    jmp exit_move 
    
down_move4:
    mov current_color, 0ah
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 12h      
    mov y_start, dx      
    call block_down_move 
     
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx 
    mov dx, current_y 
    add dx, 9h    
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    mov x_start, cx 
    mov dx, current_y  
    add dx, 9h   
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    mov x_start, cx  
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move 
     
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;can move?
    mov cx, current_x 
    mov dx, current_y
    add dx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    add cx, 9h
    add dx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    jmp exit_move
    
down_move5:
    mov current_color, 9h
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y
    add dx, 1bh      
    mov y_start, dx      
    call block_down_move 
     
    mov cx, current_x 
    mov x_start, cx 
    mov dx, current_y 
    add dx, 12h    
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    mov x_start, cx 
    mov dx, current_y  
    add dx, 9h   
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    mov x_start, cx  
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move 
     
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;can move?
    mov cx, current_x 
    mov dx, current_y
    add dx, 24h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    jmp exit_move
    
down_move6:
    mov current_color, 0dh
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y
    add dx, 12h      
    mov y_start, dx      
    call block_down_move 
     
    mov cx, current_x 
    sub cx, 9h
    mov x_start, cx 
    mov dx, current_y 
    add dx, 9h    
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    mov x_start, cx 
    mov dx, current_y  
    add dx, 9h   
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    mov x_start, cx  
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move 
     
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;can move?
    mov cx, current_x 
    mov dx, current_y
    add dx, 1bh
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    sub cx, 9h
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    jmp exit_move
    
down_move7:
    mov current_color, 0dh
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx
    mov dx, current_y
    add dx, 9h      
    mov y_start, dx      
    call block_down_move 
     
    mov cx, current_x 
    mov x_start, cx 
    mov dx, current_y 
    add dx, 9h    
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x 
    sub cx, 9h
    mov x_start, cx 
    mov dx, current_y  
    add dx, 9h   
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    mov x_start, cx  
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move 
     
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;can move?
    mov cx, current_x 
    mov dx, current_y
    add dx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move 
    sub cx, 12h
    int 10h
    cmp al, 0h
    jne no_down_move
    jmp exit_move 
    
down_move8:
    mov current_color, 0dh
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y
    add dx, 12h      
    mov y_start, dx      
    call block_down_move 
     
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx 
    mov dx, current_y 
    add dx, 9h    
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    mov x_start, cx 
    mov dx, current_y  
    add dx, 9h   
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    mov x_start, cx  
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move 
     
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;can move?
    mov cx, current_x 
    mov dx, current_y
    add dx, 1bh
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    add cx, 9h
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    jmp exit_move   
    
down_move9:
    mov current_color, 6h
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y
    add dx, 9h      
    mov y_start, dx      
    call block_down_move 
     
    mov cx, current_x 
    mov x_start, cx 
    mov dx, current_y    
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx 
    mov dx, current_y    
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x  
    add cx, 12h
    mov x_start, cx  
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move 
     
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;can move?
    mov cx, current_x 
    mov dx, current_y
    add dx, 12h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    add cx, 9h
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move   
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move
    jmp exit_move   
    
down_move10:
    mov current_color, 6h
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move 
     
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx 
    mov dx, current_y 
    add dx, 12h    
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx 
    mov dx, current_y  
    add dx, 9h   
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx  
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move 
     
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;can move?
    mov cx, current_x 
    mov dx, current_y
    add dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    add cx, 9h
    add dx, 12h
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    jmp exit_move
    
down_move11:
    mov current_color, 6h
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y      
    mov y_start, dx      
    call block_down_move 
     
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx 
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x     
    add cx, 12h
    mov x_start, cx 
    mov dx, current_y    
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    add cx, 12h
    mov x_start, cx  
    mov dx, current_y
    sub dx, 9h     
    mov y_start, dx      
    call block_down_move 
     
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;can move?
    mov cx, current_x 
    mov dx, current_y
    add dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move    
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move
    jmp exit_move 
    
down_move12:
    mov current_color, 0ah
    mov cx, current_x 
    mov x_start, cx
    mov dx, current_y      
    mov y_start, dx      
    call block_down_move 
     
    mov cx, current_x 
    add cx, 9h
    mov x_start, cx 
    mov dx, current_y     
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x     
    add cx, 9h
    mov x_start, cx 
    mov dx, current_y
    sub dx, 9h    
    mov y_start, dx      
    call block_down_move
     
    mov cx, current_x
    add cx, 12h
    mov x_start, cx  
    mov dx, current_y
    sub dx, 9h     
    mov y_start, dx      
    call block_down_move 
     
    mov dx, current_y
    add dx, 9h
    mov current_y, dx
    
    ;can move?
    mov cx, current_x 
    mov dx, current_y
    add dx, 9h
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    add cx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move ;can not move
    add cx, 9h
    sub dx, 9h
    int 10h
    cmp al, 0h
    jne no_down_move    
    jmp exit_move 

no_down_move:  
    call check_score_update
    mov bool_update_block, 1
    
exit_move:    
    ret 
down_move endp
 


check_score_update proc
    
    mov score_counter, 0h
    mov cx, 97h
    mov dx, 0b6h
    mov ah, 0dh
score_label1:
    int 10h
    cmp al, 0h     ;not completed
    je not_yet
    add cx, 9h
    cmp cx, 0f1h
    jl score_label1
    
    sub dx, 9h
    mov cx, 97h
    mov bx, score_counter
    inc bx
    mov score_counter, bx 
    cmp dx, 0bh
    jge score_label1
        
not_yet:
    mov bx, score_counter
    cmp bx, 1
    jl finish_score
    je one_line    
    jg multi_line 

one_line:
    mov bx, my_score
    add bx, 0ah
    mov my_score, bx
    call clear_line
    jmp finish_score 
    
multi_line:                 
    mov bx, my_score
    mov cx, score_counter   
multi_line_loop:
    add bx, 14h
    loop multi_line_loop
    mov my_score, bx
    call clear_line 
    jmp finish_score           
    
finish_score:      
    ret
check_score_update endp  

clear_line proc
    
    ;removing the completed lines
    mov ax, 9h
    mul score_counter
    mov dx, 0bfh
    sub dx, ax
    mov cx, 97h
    mov ah, 0ch       
    mov al, 0h ;black
clear_line_lp:
    int 10h          
    inc cx
    cmp cx, 0f1h
    jl clear_line_lp
    
    inc dx
    mov cx, 97h
    cmp dx, 0bfh
    jl clear_line_lp 
    
another_line_lp: 
    mov ax, 9h
    mul score_counter
    ;shift
    mov dx, 0bfh
    sub dx, ax
    sub dx, 9h
    xor ax, ax
    mov cx, 97h
shift_line_lp:  
    mov ah, 0dh
    int 10h
    cmp al, 0h
    jne must_shift
    je continue_check_shift

must_shift:  
    mov current_color, al
    mov x_start, cx
    mov y_start, dx
    push cx
    push dx
    call block_down_move
    pop dx
    pop cx
    
continue_check_shift:
    add cx, 9h
    cmp cx, 0f1h
    jl shift_line_lp
    
    sub dx, 9h
    mov cx, 97h
    cmp dx, 0ah
    jg shift_line_lp 
    
    dec score_counter
    cmp score_counter, 0h
    jne  another_line_lp
    
    
    call show_score
    
    ret
clear_line endp
 
 

block_down_move proc
    
    mov ntimes, 9h
main_down_loop:
    mov ah, 0ch 
    mov al, 0h 
    mov cx, x_start
    mov dx, y_start
down_move_label1: 
    int 10h 
    inc cx
    mov bx, x_start
    add bx, 8h
    cmp cx, bx
    jle down_move_label1
              
    mov al, current_color
    mov dx, y_start
    add dx, 9h
    mov cx, x_start 
down_move_label2:
    int 10h    
    inc cx
    mov bx, x_start
    add bx, 8h
    cmp cx, bx
    jle down_move_label2
    
    inc y_start   
    dec ntimes
    cmp ntimes, 0h 
    jg  main_down_loop
    
    ret
block_down_move endp

show_score proc near
    
    mov ax, my_score
    lea si, score_str
    add si, 5
    sub bx, bx
    sub dx, dx 
    
    cmp my_score, 0h
    je print_zero
    jmp div_label

print_zero:
    mov dx, 48
    add si, 1
    mov [si], dx
    
    mov ah, 02h
    mov bh, 00
    mov dh, 01h
    mov dl, 05h
    int 10h
    lea dx, score_str
    mov ah, 09h
    int 21h
    
    jmp return
    
div_label:
    sub ax, 0
    jz print_label
    mov cx, 10
    div cx       
    push dx
    inc bx
    sub dx, dx
    jmp div_label

print_label:
    cmp bx, 0
    je return
    
    pop dx
    add dx, 48
    
    ;storing in score_str
    add si, 1
    mov [si], dx
    
    mov ah, 02h
    mov bh, 00
    mov dh, 01h
    mov dl, 05h
    int 10h
    
    lea dx, score_str
    mov ah, 09h
    int 21h
    
    dec bx
    jmp print_label

return:
    ret
    
show_score endp 
