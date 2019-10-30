function lkn.list_documents(
    model_name,
    filters,
    lazy_filter,
    all_fields
)
    local documents = {}

    contentdb.walk_documents(nil,
        function (file_uuid, fields, body, store)
            if fields.model ~= model_name then return end
            -- Filter the documents using the query params
            for k, v in pairs(filters) do
                if lazy_filter then
                    if not string.find(fields[k], v) then
                        return
                    end
                else
                    if fields[k] ~= v then
                        -- Don't add this document to the list
                        return
                    end
                end
            end

            local values = {
                name = fields.name or fields.title,
                uuid = file_uuid,
                store = store
            }
            if all_fields then
                for k,v in pairs(fields) do
                    values[k] = v
                end
            end
            table.insert(documents, values)
        end
    )

    return {documents=documents}
end
