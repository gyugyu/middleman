Feature: Builder
  In order to output static html and css for delivery

  Scenario: Checking built folder for content
    Given a successfully built app at "large-build-app"
    When I cd to "build"
    Then the following files should exist:
      | index.html                                    |
      | static.html                                   |
      | services/index.html                           |
      | stylesheets/static.css                        |
      | images/blank.gif                              |
      | images/Read me (example).txt                  |
      | images/Child folder/regular_file(example).txt |
      | .htaccess                                     |
      | .htpasswd                                     |
      | feed.xml                                      |
    Then the following files should not exist:
      | _partial                                      |
      | layout                                        |
      | layouts/custom                                |
      | layouts/content_for                           |

    And the file "index.html" should contain "Comment in layout"
    And the file "index.html" should contain "<h1>Welcome</h1>"
    And the file "static.html" should contain "Static, no code!"
    And the file "services/index.html" should contain "Services"
    And the file "stylesheets/static.css" should contain "body"

  Scenario: Build glob
    Given a successfully built app at "glob-app" with flags "--glob '*.css'"
    When I cd to "build"
    Then the following files should not exist:
      | index.html                                    |
    Then the following files should exist:
      | stylesheets/site.css                          |

  Scenario: Build with errors
    Given a built app at "build-with-errors-app"
    Then the exit status should not be 0

  Scenario: Build empty errors
    Given a built app at "empty-app"
    Then was not successfully built

  Scenario: Build external_pipeline errors
    Given a built app at "external-pipeline-error"
    Then the exit status should not be 0

  Scenario: Build alias (b)
    Given a fixture app "large-build-app"
    When I run `middleman b`
    Then was successfully built

  Scenario: Build external_pipeline with helpers
    Given a successfully built app at "external-pipeline-helpers"
    When I cd to "build"
    And the file "index.html" should contain '<link href="/app-553d121b3246dc3ea415.css" rel="stylesheet" media="all" />'
    And the file "index.html" should contain '<script src="/app-6427c0e37380b2306421.js" async="async"></script>'
    And the file "another-file.html" should contain '<link href="/app-553d121b3246dc3ea415.css" rel="stylesheet" />'
    And the file "another-file.html" should contain '<script src="/app-6427c0e37380b2306421.js"></script>'

  Scenario: Builded text file(ex: html, css, xml, txt)'s permission is 0644
    Given a successfully built app at "large-build-app"
    When I cd to "build"
    Then the file named "index.html" should have permissions "0644"
    And the file named "stylesheets/static.css" should have permissions "0644"
    And the file named "feed.xml" should have permissions "0644"
    And the file named ".htaccess" should have permissions "0644"
