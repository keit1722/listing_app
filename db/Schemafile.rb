create_table 'active_storage_attachments', force: :cascade do |t|
  t.string 'name', null: false
  t.string 'record_type', null: false
  t.bigint 'record_id', null: false
  t.bigint 'blob_id', null: false
  t.datetime 'created_at', null: false
  t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
  t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness', unique: true
end

create_table 'active_storage_blobs', force: :cascade do |t|
  t.string 'key', null: false
  t.string 'filename', null: false
  t.string 'content_type'
  t.text 'metadata'
  t.string 'service_name', null: false
  t.bigint 'byte_size', null: false
  t.string 'checksum', null: false
  t.datetime 'created_at', null: false
  t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
end

create_table 'active_storage_variant_records', force: :cascade do |t|
  t.bigint 'blob_id', null: false
  t.string 'variation_digest', null: false
  t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
end

create_table 'activities', force: :cascade do |t|
  t.string 'name', null: false
  t.string 'address', null: false
  t.float 'lat', null: false
  t.float 'lng', null: false
  t.string 'slug', null: false
  t.text 'description', null: false
  t.bigint 'organization_id'
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['name'], name: 'index_activities_on_name', unique: true
  t.index ['organization_id'], name: 'index_activities_on_organization_id'
  t.index ['slug'], name: 'index_activities_on_slug', unique: true
end

create_table 'announcements', force: :cascade do |t|
  t.string 'title', null: false
  t.text 'body', null: false
  t.integer 'status', default: 1, null: false
  t.boolean 'published_before', default: false, null: false
  t.integer 'poster_id', null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
end

create_table 'authentications', force: :cascade do |t|
  t.integer 'user_id', null: false
  t.string 'provider', null: false
  t.string 'uid', null: false
  t.datetime 'created_at', precision: 6, null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.index %w[provider uid], name: 'index_authentications_on_provider_and_uid'
  t.index ['user_id'], name: 'index_authentications_on_user_id'
end

create_table 'bookmarks', force: :cascade do |t|
  t.bigint 'user_id'
  t.bigint 'bookmarkable_id'
  t.string 'bookmarkable_type'
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index %w[bookmarkable_type bookmarkable_id], name: 'index_bookmarks_on_bookmarkable_type_and_bookmarkable_id'
  t.index %w[user_id bookmarkable_id bookmarkable_type], name: 'index_bookmarks_on_user_id_and_bookmarkable_id_and_type', unique: true
  t.index ['user_id'], name: 'index_bookmarks_on_user_id'
end

create_table 'district_mappings', force: :cascade do |t|
  t.bigint 'district_id'
  t.bigint 'districtable_id'
  t.string 'districtable_type'
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['district_id'], name: 'index_district_mappings_on_district_id'
  t.index %w[districtable_id districtable_type], name: 'index_district_mappings_on_districtable_id_and_type', unique: true
  t.index %w[districtable_type districtable_id], name: 'index_polymorphic_district_mappings_on_districtable_id_and_type'
end

create_table 'districts', force: :cascade do |t|
  t.string 'name', null: false
  t.integer 'location', null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['name'], name: 'index_districts_on_name', unique: true
end

create_table 'hot_springs', force: :cascade do |t|
  t.string 'name', null: false
  t.string 'address', null: false
  t.float 'lat', null: false
  t.float 'lng', null: false
  t.string 'slug', null: false
  t.text 'description', null: false
  t.bigint 'organization_id'
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['name'], name: 'index_hot_springs_on_name', unique: true
  t.index ['organization_id'], name: 'index_hot_springs_on_organization_id'
  t.index ['slug'], name: 'index_hot_springs_on_slug', unique: true
end

create_table 'hotels', force: :cascade do |t|
  t.string 'name', null: false
  t.string 'address', null: false
  t.float 'lat', null: false
  t.float 'lng', null: false
  t.string 'slug', null: false
  t.text 'description', null: false
  t.bigint 'organization_id'
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['name'], name: 'index_hotels_on_name', unique: true
  t.index ['organization_id'], name: 'index_hotels_on_organization_id'
  t.index ['slug'], name: 'index_hotels_on_slug', unique: true
end

create_table 'incoming_emails', force: :cascade do |t|
  t.bigint 'user_id'
  t.boolean 'post', default: true, null: false
  t.boolean 'announcement', default: true, null: false
  t.boolean 'organization', default: true, null: false
  t.boolean 'organization_invitation', default: true, null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['user_id'], name: 'index_incoming_emails_on_user_id'
end

create_table 'notices', force: :cascade do |t|
  t.bigint 'user_id'
  t.bigint 'noticeable_id'
  t.string 'noticeable_type'
  t.boolean 'read', default: false, null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index %w[noticeable_type noticeable_id], name: 'index_notices_on_noticeable_type_and_noticeable_id'
  t.index ['user_id'], name: 'index_notices_on_user_id'
end

create_table 'opening_hours', force: :cascade do |t|
  t.bigint 'opening_hourable_id'
  t.string 'opening_hourable_type'
  t.string 'start_time_hour', null: false
  t.string 'start_time_minute', null: false
  t.string 'end_time_hour', null: false
  t.string 'end_time_minute', null: false
  t.integer 'day', null: false
  t.boolean 'closed', default: false, null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index %w[opening_hourable_type opening_hourable_id], name: 'index_polymorphic_opening_hour_mappings_on_id_and_type'
end

create_table 'organization_invitations', force: :cascade do |t|
  t.bigint 'organization_id'
  t.integer 'inviter_id', null: false
  t.string 'email', null: false
  t.string 'token', null: false
  t.datetime 'expires_at', precision: 6, null: false
  t.integer 'status', default: 1, null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['organization_id'], name: 'index_organization_invitations_on_organization_id'
  t.index ['token'], name: 'index_organization_invitations_on_token', unique: true
end

create_table 'organization_registration_statuses', force: :cascade do |t|
  t.bigint 'organization_registration_id'
  t.integer 'status', null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['organization_registration_id'], name: 'index_org_registration_statuses_on_org_registration_id'
end

create_table 'organization_registrations', force: :cascade do |t|
  t.bigint 'user_id'
  t.string 'organization_name', null: false
  t.string 'organization_address', null: false
  t.string 'organization_phone', null: false
  t.text 'business_detail', null: false
  t.string 'token', null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['user_id'], name: 'index_organization_registrations_on_user_id'
end

create_table 'organization_users', force: :cascade do |t|
  t.bigint 'user_id'
  t.bigint 'organization_id'
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['organization_id'], name: 'index_organization_users_on_organization_id'
  t.index %w[user_id organization_id], name: 'index_organization_users_on_user_id_and_organization_id', unique: true
  t.index ['user_id'], name: 'index_organization_users_on_user_id'
end

create_table 'organizations', force: :cascade do |t|
  t.string 'name', null: false
  t.string 'address', null: false
  t.string 'phone', null: false
  t.string 'slug', null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['name'], name: 'index_organizations_on_name', unique: true
  t.index ['slug'], name: 'index_organizations_on_slug', unique: true
end

create_table 'page_shows', force: :cascade do |t|
  t.bigint 'page_showable_id'
  t.string 'page_showable_type'
  t.boolean 'reservation_link', default: true, null: false
  t.boolean 'opening_hours', default: true, null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index %w[page_showable_type page_showable_id], name: 'index_page_shows_on_page_showable_type_and_page_showable_id'
end

create_table 'photo_spots', force: :cascade do |t|
  t.string 'name', null: false
  t.string 'address', null: false
  t.float 'lat', null: false
  t.float 'lng', null: false
  t.string 'slug', null: false
  t.text 'description', null: false
  t.bigint 'organization_id'
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['name'], name: 'index_photo_spots_on_name', unique: true
  t.index ['organization_id'], name: 'index_photo_spots_on_organization_id'
  t.index ['slug'], name: 'index_photo_spots_on_slug', unique: true
end

create_table 'posts', force: :cascade do |t|
  t.bigint 'postable_id'
  t.string 'postable_type'
  t.string 'title', null: false
  t.text 'body', null: false
  t.integer 'status', null: false
  t.boolean 'published_before', default: false, null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index %w[postable_type postable_id], name: 'index_posts_on_postable_type_and_postable_id'
end

create_table 'reservation_links', force: :cascade do |t|
  t.bigint 'reservation_linkable_id'
  t.string 'reservation_linkable_type'
  t.string 'link'
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index %w[reservation_linkable_type reservation_linkable_id], name: 'index_polymorphic_reservation_link_mappings_on_id_and_type'
end

create_table 'restaurant_categories', force: :cascade do |t|
  t.string 'name', null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['name'], name: 'index_restaurant_categories_on_name', unique: true
end

create_table 'restaurant_category_mappings', force: :cascade do |t|
  t.bigint 'restaurant_id'
  t.bigint 'restaurant_category_id'
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['restaurant_category_id'], name: 'index_restaurant_category_mappings_on_restaurant_category_id'
  t.index %w[restaurant_id restaurant_category_id], name: 'index_restaurant_category_mappings_on_id_and_category_id', unique: true
  t.index ['restaurant_id'], name: 'index_restaurant_category_mappings_on_restaurant_id'
end

create_table 'restaurants', force: :cascade do |t|
  t.string 'name', null: false
  t.string 'address', null: false
  t.float 'lat', null: false
  t.float 'lng', null: false
  t.string 'slug', null: false
  t.text 'description', null: false
  t.bigint 'organization_id'
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['name'], name: 'index_restaurants_on_name', unique: true
  t.index ['organization_id'], name: 'index_restaurants_on_organization_id'
  t.index ['slug'], name: 'index_restaurants_on_slug', unique: true
end

create_table 'shop_categories', force: :cascade do |t|
  t.string 'name', null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['name'], name: 'index_shop_categories_on_name', unique: true
end

create_table 'shop_category_mappings', force: :cascade do |t|
  t.bigint 'shop_id'
  t.bigint 'shop_category_id'
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['shop_category_id'], name: 'index_shop_category_mappings_on_shop_category_id'
  t.index %w[shop_id shop_category_id], name: 'index_shop_category_mappings_on_id_and_category_id', unique: true
  t.index ['shop_id'], name: 'index_shop_category_mappings_on_shop_id'
end

create_table 'shops', force: :cascade do |t|
  t.string 'name', null: false
  t.string 'address', null: false
  t.float 'lat', null: false
  t.float 'lng', null: false
  t.string 'slug', null: false
  t.text 'description', null: false
  t.bigint 'organization_id'
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['name'], name: 'index_shops_on_name', unique: true
  t.index ['organization_id'], name: 'index_shops_on_organization_id'
  t.index ['slug'], name: 'index_shops_on_slug', unique: true
end

create_table 'ski_areas', force: :cascade do |t|
  t.string 'name', null: false
  t.string 'address', null: false
  t.float 'lat', null: false
  t.float 'lng', null: false
  t.string 'slug', null: false
  t.text 'description', null: false
  t.bigint 'organization_id'
  t.datetime 'updated_at', precision: 6, null: false
  t.datetime 'created_at', precision: 6, null: false
  t.index ['name'], name: 'index_ski_areas_on_name', unique: true
  t.index ['organization_id'], name: 'index_ski_areas_on_organization_id'
  t.index ['slug'], name: 'index_ski_areas_on_slug', unique: true
end

create_table 'users', force: :cascade do |t|
  t.string 'email', null: false
  t.string 'crypted_password'
  t.string 'salt'
  t.string 'first_name', null: false
  t.string 'last_name', null: false
  t.string 'username', null: false
  t.integer 'role', default: 1, null: false
  t.string 'public_uid'
  t.datetime 'created_at', precision: 6, null: false
  t.datetime 'updated_at', precision: 6, null: false
  t.string 'activation_state'
  t.string 'activation_token'
  t.datetime 'activation_token_expires_at'
  t.string 'reset_password_token'
  t.datetime 'reset_password_token_expires_at'
  t.datetime 'reset_password_email_sent_at'
  t.integer 'access_count_to_reset_password_page', default: 0
  t.index ['activation_token'], name: 'index_users_on_activation_token'
  t.index ['email'], name: 'index_users_on_email', unique: true
  t.index ['public_uid'], name: 'index_users_on_public_uid', unique: true
  t.index ['reset_password_token'], name: 'index_users_on_reset_password_token'
end
