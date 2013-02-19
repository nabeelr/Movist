//
//  Movist
//
//  Copyright 2006 ~ 2008 Yong-Hoe Kim. All rights reserved.
//      Yong-Hoe Kim  <cocoable@gmail.com>
//
//  This file is part of Movist.
//
//  Movist is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 3 of the License, or
//  (at your option) any later version.
//
//  Movist is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "MMovieView.h"

#import "MMovie.h"
#import "MMovieOSD.h"
#import "AppController.h"   // for NSApp's delegate
#import "MMovieViewLayer.h"

@implementation MMovieView (OSD)

- (BOOL)initOSD
{
    NSRect bounds = [self bounds];
    int i;
    NSColor* subtitleMessageTextColor, *subtitleMessageStrokeColor;
    subtitleMessageTextColor = [NSColor colorWithCalibratedRed:1 green:1 blue:1 alpha:0.5];
    subtitleMessageStrokeColor = [NSColor colorWithCalibratedRed:1 green:1 blue:1 alpha:0.5];
    for (i = 0; i < 3; i++) {
        _subtitleOSD[i] = [[MMovieOSD alloc] init];
        [_subtitleOSD[i] initTextRendering];
        [_subtitleOSD[i] setViewBounds:bounds movieRect:bounds autoSizeWidth:0];

        _auxSubtitleOSD[i] = [[MMovieOSD alloc] init];
        [_auxSubtitleOSD[i] initTextRendering];
        [_auxSubtitleOSD[i] setShadowBlur:0];   // no shadow
        [_auxSubtitleOSD[i] setViewBounds:bounds movieRect:bounds autoSizeWidth:0];

        // h/v-position will be updated later
    }
    _subtitleVisible = TRUE;
    _indexOfSubtitleInLBOX = -1;
    _autoLetterBoxHeightMaxLines = 3;

    _messageOSD = [[MMovieOSD alloc] init];
    [_messageOSD initTextRendering];
    [_messageOSD setViewBounds:bounds movieRect:bounds autoSizeWidth:0];
    [_messageOSD setHPosition:OSD_HPOSITION_LEFT];
    [_messageOSD setVPosition:OSD_VPOSITION_TOP];
    [_messageOSD setTextAlignment:NSLeftTextAlignment];
    _messageHideInterval = 2.0;

    _errorOSD = [[MMovieOSD alloc] init];
    [_errorOSD initTextRendering];
    [_errorOSD setViewBounds:bounds movieRect:bounds autoSizeWidth:0];
    [_errorOSD setHPosition:OSD_HPOSITION_CENTER];
    [_errorOSD setVPosition:OSD_VPOSITION_CENTER];
    [_errorOSD setTextAlignment:NSCenterTextAlignment];

    _iconOSD = [[MMovieOSD alloc] init];
    [_iconOSD setViewBounds:bounds movieRect:bounds autoSizeWidth:0];
    [_iconOSD setImage:[NSImage imageNamed:@"Movist"]];
    [_iconOSD setHPosition:OSD_HPOSITION_CENTER];
    [_iconOSD setVPosition:OSD_VPOSITION_CENTER];
    return TRUE;
}

- (void)cleanupOSD
{
    //TRACE(@"%s", __PRETTY_FUNCTION__);
    [_iconOSD release];
    [_errorOSD release];
    [_messageOSD release];
    [_subtitleOSD[0] release];
    [_subtitleOSD[1] release];
    [_subtitleOSD[2] release];
    [_auxSubtitleOSD[0] release];
    [_auxSubtitleOSD[1] release];
    [_auxSubtitleOSD[2] release];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)drawOSD
{
    //TRACE(@"%s", __PRETTY_FUNCTION__);
    if ([_iconOSD hasContent]) {
        [_iconOSD drawOnScreen];
    }
    if (_subtitleVisible) {
        int i;
        for (i = 2; 0 <= i; i--) {
            if ([_subtitleOSD[i] hasContent]) {
                [_subtitleOSD[i] drawOnScreen];
            }
            else if ([_auxSubtitleOSD[i] hasContent]) {
                [_auxSubtitleOSD[i] drawOnScreen];
            }
        }
    }
    if ([_messageOSD hasContent]) {
        [_messageOSD drawOnScreen];
    }
    if ([_errorOSD hasContent]) {
        [_errorOSD drawOnScreen];
    }
}

- (void)clearOSD
{
    [_subtitleOSD[0] setSubtitleSync:0], [_subtitleOSD[0] clearContent];
    [_subtitleOSD[1] setSubtitleSync:0], [_subtitleOSD[1] clearContent];
    [_subtitleOSD[2] setSubtitleSync:0], [_subtitleOSD[2] clearContent];
    [_messageOSD clearContent];
    [_errorOSD clearContent];
}

- (void)updateOSDImageBaseWidth
{
    float width = (self.movie) ? [self.movie adjustedSizeByAspectRatio].width : 0;
    [_subtitleOSD[0] setImageBaseWidth:width];
    [_subtitleOSD[1] setImageBaseWidth:width];
    [_subtitleOSD[2] setImageBaseWidth:width];
}

- (void)showLogo
{
	_rootLayer.icon.hidden = NO;
}

- (void)hideLogo
{
	_rootLayer.icon.hidden = YES;
}

@end
