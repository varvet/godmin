module Godmin
  class Resolver < ::ActionView::FileSystemResolver
    def initialize
      super("app/views")
      debugger
      puts "hello"
    end

    def find_templates(name, prefix, partial, details)
    #   # prefix = ["godmin", prefix.split("/").last].join("/")
    #   #
    #   # x = super(name, prefix, partial, details)
    #   # debugger
    #   #
    #   # x
    #
    #   super("welcome-no", prefix, partial, details)
    #
      debugger
      super
    end
  end
end
