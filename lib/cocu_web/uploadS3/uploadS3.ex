defmodule CocuWeb.UploadS3 do

    def insertImageForUser(picture_path_params, user_params) do
      bucket_name = "co-creative-universe"
      unique_filename = createUniqueImageName(picture_path_params.filename)
      insertImage(unique_filename, picture_path_params.path)
      Map.update!(user_params, "picture_path", fn _value -> "https://s3.eu-central-1.amazonaws.com/#{bucket_name}/#{unique_filename}" end)
    end

    def insertImage(unique_filename, path) do
      bucket_name = "co-creative-universe"
      {:ok, image_binary} = File.read(path)
      ExAws.S3.put_object(bucket_name, unique_filename, image_binary)
        |> ExAws.request!
    end

    def insertImage(picture_params) do
      unique_filename = createUniqueImageName(picture_params.filename)
      bucket_name = "co-creative-universe"
      {:ok, image_binary} = File.read(picture_params.path)
      ExAws.S3.put_object(bucket_name, unique_filename, image_binary)
        |> ExAws.request!

      "https://s3.eu-central-1.amazonaws.com/#{bucket_name}/#{unique_filename}"
    end

    def deleteImageFromS3(image_url) do
      old_image_url = Enum.at(String.split(image_url, "co-creative-universe/"), 1)
      ExAws.S3.delete_object("co-creative-universe", old_image_url)
        |> ExAws.request!
    end

    def createUniqueImageName(filename) do
      file_uuid = UUID.uuid4(:hex)
      image_filename = filename
      "#{file_uuid}-#{image_filename}"
    end
  end