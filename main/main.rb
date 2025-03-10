# frozen_string_literal: true
require 'ruby_grammar_builder'
require 'walk_up'
require_relative walk_up_until("paths.rb")
require_relative './tokens.rb'

# 
# 
# create grammar!
# 
# 
grammar = Grammar.fromTmLanguage("./main/original.tmLanguage.json")
# grammar = Grammar.new(
#     name: "MATLAB",
#     scope_name: "source.m",
#     fileTypes: [
#         "m",
#         # for example here are come C++ file extensions:
# 		#     "cpp",
# 		#     "cxx",
# 		#     "c++",
#     ],
#     version: "",
# )

# 
#
# Setup Grammar
#
# 
    # grammar[:$initial_context] = [
    #     :comments,
    #     :string,
    #     :variable,
    #     # (add more stuff here) (variables, strings, numbers)
    # ]

# 
# Helpers
# 
    # @space
    # @spaces
    # @digit
    # @digits
    # @standard_character
    # @word
    # @word_boundary
    # @white_space_start_boundary
    # @white_space_end_boundary
    # @start_of_document
    # @end_of_document
    # @start_of_line
    # @end_of_line
    part_of_a_variable = /[a-zA-Z_][a-zA-Z_0-9]*/
    # this is really useful for keywords. eg: variableBounds[/new/] wont match "newThing" or "thingnew"
    variableBounds = ->(regex_pattern) do
        lookBehindToAvoid(@standard_character).then(regex_pattern).lookAheadToAvoid(@standard_character)
    end
    variable = variableBounds[part_of_a_variable]
    
# 
# basic patterns
# 
    grammar[:variable] = Pattern.new(
        match: variable,
        tag_as: "variable.other",
    )
    
    grammar[:line_continuation_character] = Pattern.new(
        match: /\\\n/,
        tag_as: "constant.character.escape.line-continuation",
    )
    
    grammar[:attribute] = PatternRange.new(
        start_pattern: Pattern.new(
                match: /\[\[/,
                tag_as: "punctuation.section.attribute.begin"
            ),
        end_pattern: Pattern.new(
                match: /\]\]/,
                tag_as: "punctuation.section.attribute.end",
            ),
        tag_as: "support.other.attribute",
        # tag_content_as: "support.other.attribute", # <- alternative that doesnt double-tag the start/end
        includes: [
            :attributes_context,
        ]
    )

# 
# imports
# 
    grammar.import(PathFor[:pattern]["comments"])
    grammar.import(PathFor[:pattern]["string"])
    grammar.import(PathFor[:pattern]["numeric_literal"])

#
# Save
#
name = "m"
grammar.save_to(
    syntax_name: name,
    syntax_dir: "./autogenerated",
    tag_dir: "./autogenerated",
)