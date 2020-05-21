;;; elcast.el --- Play Elfeed podcast enclosures with mpv.  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Doug Davis

;; Author: Doug Davis <ddavis@ddavis.io>
;; URL: https://github.com/douglasdavis/elcast
;; Keywords: tools
;; Version: 0.1
;; Package-Requires: ((elfeed "3.0.0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; A tiny package for playing podcasts with `elfeed' in mpv.

;;; Code:


(require 'elfeed)

(defgroup elcast nil
  "Tool for playing podcasts from `elfeed' enclosures."
  :group 'tools)

(defcustom elcast-playback-speed 1.25
  "Playback speed for listening with mpv."
  :type 'number)

(defcustom elcast-buffer-name "*elcast*"
  "Name of buffer for mpv process."
  :type 'string)

(defvar elcast-mpv-executable (executable-find "mpv")
  "Path to the mpv executable.")

(defun elcast--get-url (show-entry)
  "Get the enclosure url associated with SHOW-ENTRY."
  (let ((enclosure (elfeed-entry-enclosures show-entry)))
    (car (elt enclosure 0))))

(defun elcast--launch-for-url (url)
  "Build the mpv command to play URL."
  (let ((exe elcast-mpv-executable)
        (buff elcast-buffer-name)
        (speed (format "--speed=%.2f" elcast-playback-speed)))
    (if (and exe (file-exists-p exe))
        (start-process "elcast" buff exe
                       "--quiet" "--vid=no" speed url)
      (user-error (format "%s doesn't exist" exe)))))

;;;###autoload
(defun elcast-play ()
  "Play the `elfeed' podcast entry enclosure."
  (interactive)
  (let ((entry elfeed-show-entry))
    (if entry
        (elcast--launch-for-url (elcast--get-url entry))
      (user-error "No show entry."))))

(provide 'elcast)
;;; elcast.el ends here
