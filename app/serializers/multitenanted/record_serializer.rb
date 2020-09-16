module Multitenanted
  class RecordSerializer
    include FastJsonapi::ObjectSerializer

    set_type :record

    attributes :values, :created_at, :updated_at
  end
end

# module Blog
#   # Serializer for log posts, following jsonapi.org specifications
#   # specifically for relations and link
#   class PostSerializer
#     include FastJsonapi::ObjectSerializer

#     set_type :blog_post

#     belongs_to :author, record_type: :author

#     has_many :comments

#     has_many :properties, serializer: PropertySerializer # overwrite otherwise it tries to namespace

#     attributes :title, :slug, :created_at, :updated_at

#     attribute :featured_image do |post|
#       Rails.application.routes.url_helpers.url_for post.featured_image
#     end

#     attribute :body do |post|
#       # Ok .body.body gives us the html BEFORE rails adds in the captions and stuff onto it
#       # it basically gives some weird attachment tag with a bunch of encoded stuff in the sgid
#       # that tells it what else to render in, then we call the render method which actually then
#       # applies the rest of the stuff like sizing, captions, the image tag etc over the html.
#       # squish to remove newlines n that
#       post.body&.body&.to_rendered_html_with_layout&.squish
#     end

#     attribute :restricted, &:restricted?
#   end
# end
