module Enki
  module ApplicationHelper
    
    def author
      Struct.new(:name, :email).new(Enki.config[:author][:name], Enki.config[:author][:email])
    end

    def open_id_delegation_link_tags(server, delegate)
      raw links = <<-EOS
        <link rel="openid.server" href="#{server}">
        <link rel="openid.delegate" href="#{delegate}">
      EOS
    end

    def format_comment_error(error)
      {
        'body'   => 'Please comment',
        'author' => 'Please provide your name or OpenID identity URL',
        'base'   => error.last
      }[error.first.to_s]
    end

    def comments?
      Enki.config[:features, :comments]
    end
    
    def tags?
      Enki.config[:features, :tags]
    end

  end
end