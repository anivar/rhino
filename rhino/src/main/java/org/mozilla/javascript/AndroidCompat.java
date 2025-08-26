/* -*- Mode: java; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.javascript;

/**
 * Simple Android compatibility helper.
 *
 * <p>Provides minimal Android detection for automatic interpreter mode selection.
 */
class AndroidCompat {

    private static final boolean IS_ANDROID = checkAndroid();

    private static boolean checkAndroid() {
        try {
            // More reliable than checking VM name - detects both Dalvik and ART
            Class.forName("android.os.Build");
            return true;
        } catch (ClassNotFoundException e) {
            return false;
        }
    }

    /** Returns true if running on Android. */
    static boolean isAndroid() {
        return IS_ANDROID;
    }
}
