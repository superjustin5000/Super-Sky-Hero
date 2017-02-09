/*
 Copyright (C) 2011 by Stuart Carnie
 
 Modified by Chris Jorgensen for compatibility with the GameDock for iOS
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

typedef enum GameDockState {
    GameDockJoystickNone       = 0x000,
    GameDockJoystickUp         = 0x001,
    GameDockJoystickRight      = 0x002,
    GameDockJoystickDown       = 0x004,
    GameDockJoystickLeft       = 0x008,
    
    GameDockJoystickUpRight    = GameDockJoystickUp   | GameDockJoystickRight,
    GameDockJoystickDownRight  = GameDockJoystickDown | GameDockJoystickRight,
    GameDockJoystickUpLeft     = GameDockJoystickUp   | GameDockJoystickLeft,
    GameDockJoystickDownLeft   = GameDockJoystickDown | GameDockJoystickLeft,
    
    GameDockButtonA            = 0x010,
    GameDockButtonB            = 0x020,
    GameDockButtonC            = 0x040,
    GameDockButtonD            = 0x080,
    GameDockButtonE            = 0x100,
    GameDockButtonF            = 0x200,
    GameDockButtonG            = 0x400,
    GameDockButtonH            = 0x800,
    
    GameDockJoystick2None       = 0x000000,
    GameDockJoystick2Up         = 0x001000,
    GameDockJoystick2Right      = 0x002000,
    GameDockJoystick2Down       = 0x004000,
    GameDockJoystick2Left       = 0x008000,
    
    GameDockJoystickUp2Right    = GameDockJoystick2Up   | GameDockJoystick2Right,
    GameDockJoystickDown2Right  = GameDockJoystick2Down | GameDockJoystick2Right,
    GameDockJoystickUp2Left     = GameDockJoystick2Up   | GameDockJoystick2Left,
    GameDockJoystickDown2Left   = GameDockJoystick2Down | GameDockJoystick2Left,
    
    GameDockButton2A            = 0x010000,
    GameDockButton2B            = 0x020000,
    GameDockButton2C            = 0x040000,
    GameDockButton2D            = 0x080000,
    GameDockButton2E            = 0x100000,
    GameDockButton2F            = 0x200000,
    GameDockButton2G            = 0x400000,
    GameDockButton2H            = 0x800000,
    
} GameDockState;
