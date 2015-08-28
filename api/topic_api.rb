class Imager::TopicAPI < Grape::API
  resources :topics do

    params do
      optional :limit, type: Integer, desc: 'count', default: 20
      optional :older, type: Integer, desc: 'direction', values: [1, 0], default: 1
      optional :from_id, type: Integer, desc: 'start id'
    end
    get do
      params[:older] = params[:older] == 1
      topics = Topic.timeline params.slice(:limit, :older, :from_id)
      topics.map(&:as_simple_json)
    end

    route_param :id do
      before do
        @topic = Topic.find(params[:id])
      end
      get do
        @topic
      end

      get :view do
        env['api.format'] = :binary # there's no formatter for :binary, data will be returned "as is"
        content_type @topic.content_type
        @topic.v_image.read
      end

      delete do
        @topic.destroy
        @topic
      end

      resources :versions do
        get do
          @topic.urls
        end

        params do
          optional :v, type: Symbol, desc: 'version', default: :default
        end
        route_param :v do
          get do #topics/1/versions/s50
            env['api.format'] = :binary # there's no formatter for :binary, data will be returned "as is"
            content_type @topic.content_type
            @topic.v_image(params[:v]).read
          end
        end
      end #versions resources
    end # route_param :id
  end # topics
end
