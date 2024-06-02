;  boot.S - bootstrap the kernel 
;  Copyright (C) 1999, 2001, 2010  Free Software Foundation, Inc.
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
use32
global loader
extern kernelMain


%include "multiboot2.inc"

;  The size of our stack (16KB). 
%define STACK_SIZE                      0x4000
; Prefer explicate declarations
%define u8      db    
%define u16     dw    
%define u32     dd    
%define u64     dq        

       
align  8        
section .text


multiboot_header:
        u32 MULTIBOOT2_HEADER_MAGIC
        u32 MULTIBOOT_ARCHITECTURE_I386
        u32 multiboot_header_end - multiboot_header
        u32 -(MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (multiboot_header_end - multiboot_header))

; framebuffer_tag_start:  
;         u16 MULTIBOOT_HEADER_TAG_FRAMEBUFFER
;         u16 MULTIBOOT_HEADER_TAG_OPTIONAL
;         u32 framebuffer_tag_end - framebuffer_tag_start
;         u16 1024
;         u16 768
;         u32 32
; framebuffer_tag_end:

address_tag_start:      
        u16 MULTIBOOT_HEADER_TAG_ADDRESS
        u16 MULTIBOOT_HEADER_TAG_OPTIONAL
        u32 address_tag_end - address_tag_start
        u32 multiboot_header
        u32 loader
        u32 _edata
        u32 kernel_stack
address_tag_end:

entry_address_tag_start:        
        u16 MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS
        u16 MULTIBOOT_HEADER_TAG_OPTIONAL
        u32 entry_address_tag_end - entry_address_tag_start
        u32 loader
entry_address_tag_end:

        u16 MULTIBOOT_HEADER_TAG_END
        u16 0
        u32 0
        u32 8

multiboot_header_end:

; .. other vars here

loader:
        lea    esp, kernel_stack

;          Reset EFLAGS.
        push   0
        popf

        ; Now enter the C main function...
        call    kernelMain

        ; Halt.
loop:   hlt
        jmp     loop

section .bss        
        ; stack space
        resb STACK_SIZE
kernel_stack:


section .data
_edata:
