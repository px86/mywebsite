(defun pr/read-file-into-string (file)
  "Read the contents of FILE into a string."
  (with-temp-buffer
    (insert-file-contents file)
    (buffer-string)))

(setq org-export-global-macros
      '(("timestamp" . "@@html:<span class=\"timestamp\">[$1]</span>@@")))

(defun pr/org-sitemap-date-entry-format (entry style project)
  "Format ENTRY in org-publish PROJECT Sitemap format ENTRY ENTRY STYLE format that includes date."
  (let ((filename (org-publish-find-title entry project)))
    (if (= (length filename) 0)
        (format "*%s*" entry)
      (format "{{{timestamp(%s)}}} [[file:%s][%s]]"
              (format-time-string "%Y-%m-%d"
                                  (org-publish-find-date entry project))
              entry
              filename))))

(setq org-html-preamble (pr/read-file-into-string "site-content/assets/header.html"))
(setq org-html-postamble (pr/read-file-into-string "site-content/assets/footer.html"))

(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents (package-refresh-contents))

(package-install 'htmlize)

(require 'ox-publish)

;; Set the project publish configuration
(setq org-publish-project-alist
      (list
       (list "articles"
	     :recursive t
	     :base-directory "./site-content/articles"
	     :publishing-directory "./public/articles"
	     :publishing-function 'org-html-publish-to-html
	     :with-creator t
	     :with-toc nil
	     :auto-sitemap t
	     :sitemap-title "All Articles"
	     :sitemap-filename "index.org"
	     :sitemap-style 'list
	     :sitemap-format-entry 'pr/org-sitemap-date-entry-format
	     :sitemap-sort-files 'anti-chronologically
	     :section-numbers nil)
       (list "site-pages"
	     :recursive nil
	     :base-directory "./site-content"
	     :publishing-directory "./public"
	     :publishing-function 'org-html-publish-to-html
	     :with-creator t
	     :with-toc nil
	     :section-numbers nil)
       (list "static-files"
	     :recursive t
	     :base-directory  "./site-content/assets"
	     :publishing-directory "./public/assets"
	     :base-extension "css\\|js\\|png\\|jpg\\|gif\\|svg\\|ico\\|pdf\\|mp3\\|wav\\|woff2?\\|ttf"
	     :publishing-function 'org-publish-attachment
	     )))

;; Only add css classes into the HTML, do not include inline styles
(setq org-html-htmlize-output-type 'css)

(setq org-html-metadata-timestamp-format "%Y-%m-%d")

;; Do not include the validation link
(setq org-html-validation-link nil)

(setq org-html-doctype "html5"
      org-html-html5-fancy t
      org-html-head-include-scripts nil
      org-html-head-include-default-style nil)

;; Include custom css/js into the exported HTML head
(setq org-html-head-extra
      (concat "<link rel=\"icon\" type=\"image/x-icon\" href=\"/assets/favicon.ico\"/> \n"
	      "<link rel=\"stylesheet\" type=\"text/css\" href=\"/assets/css/style.css\"/> \n"
	      "<link rel=\"stylesheet\" type=\"text/css\" href=\"/assets/css/fonts.css\"/> \n"
	      "<script type=\"text/javascript\" src=\"/assets/js/script.js\" defer></script> \n"))

;; Use html5 elements instead of just `div'
(setq org-html-divs
      '((preamble "header" "preamble")
	(content "main" "content")
	(postamble "footer" "postamble")))

;; Publish all the projects
(org-publish-all t)

(message "Build complete")
