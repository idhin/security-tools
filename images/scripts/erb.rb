require 'erb'
require 'yaml'

def generate_badge array
    badge = ""
    array.each { |t|
        case t
        when 'linux'
            badge = badge + "![linux](./images/linux.png)"
        when 'windows'
            badge = badge + "![windows](./images/windows.png)"
        when 'macos'
            badge = badge + "![macos](./images/apple.png)"
        when 'firefox'
            badge = badge + "![firefox](./images/firefox.png)"
        when 'safari'
            badge = badge + "![safari](./images/safari.png)"
        when 'chrome'
            badge = badge + "![chrome](./images/chrome.png)"
        when 'burpsuite'
            badge = badge + "![burp](./images/burp.png)"
        when 'zap'
            badge = badge + "![zap](./images/zap.png)"
        end
    }
    return badge
end

def generate_tags array
    tags = ""
    array.each { |t|
        tags = tags + "`#{t}` "
    }
    return tags
end

template = %q{
<h1 align="center">
<br>
<a href=""><img src="https://user-images.githubusercontent.com/13212227/104400969-9f3d9280-5596-11eb-80f4-864effae95fc.png" alt="" width="500px;"></a>
<br>
<img src="https://img.shields.io/github/last-commit/hahwul/WebHackersWeapons?style=flat"> 
<img src="https://img.shields.io/badge/PRs-welcome-cyan">
<img src="https://github.com/hahwul/WebHackersWeapons/actions/workflows/deploy.yml/badge.svg">
<a href="https://twitter.com/intent/follow?screen_name=hahwul"><img src="https://img.shields.io/twitter/follow/hahwul?style=flat&logo=twitter"></a>
</h1>
A collection of awesome tools used by Web hackers. Happy hacking , Happy bug-hunting

## Family project
[![WebHackersWeapons](https://img.shields.io/github/stars/hahwul/WebHackersWeapons?label=WebHackersWeapons)](https://github.com/hahwul/WebHackersWeapons)
[![MobileHackersWeapons](https://img.shields.io/github/stars/hahwul/MobileHackersWeapons?label=MobileHackersWeapons)](https://github.com/hahwul/MobileHackersWeapons)

## Table of Contents
- [Weapons](#weapons)
    - [Tools](#tools)
    - [Bookmarklets](#bookmarklets)
    - [Browser Addons](#browser-addons)
    - [Burp and ZAP Addons](#burpsuite-and-zap-addons)
- [Contribute](CONTRIBUTING.md) 
- [Thanks to contributor](#thanks-to-contributor)

## Weapons
*Attributes*
|       | Attributes                                        |
|-------|---------------------------------------------------|
| Types | `Army-Knife` `Proxy` `Recon` `Fuzzer` `Scanner` `Exploit` `Env` `Utils` `Etc`|
| Tags  | <%= tags.uniq.join ' ' %>                         |
| Langs | <%= langs.uniq.join ' ' %>                        |

### Tools
<%= tools %>

### Bookmarklets
<%= bookmarklets %>

### Browser Addons
<%= browser_addons %>

### Burpsuite and ZAP Addons
<%= tool_addons %>

## Thanks to (Contributor)
WHW's open-source project and made it with ❤️ if you want contribute this project, please see [CONTRIBUTING.md](https://github.com/hahwul/WebHackersWeapons/blob/main/CONTRIBUTING.md) and Pull-Request with cool your contents.

[![](/images/CONTRIBUTORS.svg)](https://github.com/hahwul/WebHackersWeapons/graphs/contributors)

}.gsub(/^  /, '')

tags = []
langs = []
head = "| Type | Name | Description | Star | Tags | Badges |\n"
head = head + "| --- | --- | --- | --- | --- | --- |"
tools = head + "\n"
bookmarklets = head + "\n"
browser_addons = head + "\n"
tool_addons = head + "\n"

weapons = []
weapons_obj = {
    "army-knife" => [],
    "proxy" => [],
    "recon"=> [],
    "fuzzer"=> [],
    "scanner"=> [],
    "exploit"=> [],
    "utils"=> [],
    "etc"=> []
}

Dir.entries("./weapons/").each do | name |
    if name != '.' && name != '..'
        begin
            data = YAML.load(File.open("./weapons/#{name}"))
            if data['type'] != "" && data['type'] != nil
                weapons_obj[data['type'].downcase].push data
            else
                weapons_obj['etc'].push data
            end
        rescue => e 
            puts e
        end
    end
end
weapons_obj.each do |key,value|
    weapons.concat value
end

weapons.each do | data |
    begin
        name = data['name']
        temp_tags = []
        begin
          data['tags'].each do |t|
             temp_tags.push "`#{t}`"
          end
          tags.concat temp_tags
        rescue
        end
        lang_badge = ""
        begin
          if data['lang'].length > 0 && data['lang'] != "null"
              langs.push "`#{data['lang']}`"
              lang_badge = "![](./images/#{data['lang'].downcase}.png)"
          end
        rescue
        end
        
        popularity = ""

        if data['url'].length > 0 
            name = "[#{name}](#{data['url']})"
        end

        if data['url'].include? "github.com"
            split_result = data['url'].split "//github.com/"
            popularity = "![](https://img.shields.io/github/stars/#{split_result[1]}?label=%20)"
        end
        badge = generate_badge(data['platform'])
        line = "|#{data['type']}|#{name}|#{data['description']}|#{popularity}|#{temp_tags.join ' '}|#{badge}#{lang_badge}|"
        case data['category'].downcase 
        when 'tool'
            tools = tools + line + "\n"
        when 'tool-addon'
            tool_addons = tool_addons + line + "\n"
        when 'browser-addon'
            browser_addons = browser_addons + line + "\n"
        when 'bookmarklet'
            bookmarklets = bookmarklets + line + "\n"
        else
            puts name
        end
    rescue => e 
        puts e
    end
end

markdown = ERB.new(template, trim_mode: "%<>")
#puts markdown.result
File.write './README.md', markdown.result
