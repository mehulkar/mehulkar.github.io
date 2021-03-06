#!/usr/bin/env ruby
require 'fileutils'
require_relative '../lib/new_post'

print "Name of post: "
title = gets.chomp

puts "Creating new post"
post = NewPost.new(title).tap(&:create)

puts "Checking out new branch"
`git checkout -b post/#{post.parameterized_title}`

puts "Opening #{post.file_path}"
`code . -g #{post.file_path}`

# exit(0)
