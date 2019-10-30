function lkn.save_doc(fields)
    local document_uuid = uuid.v4()
    local store = contentdb.home

    contentdb.write_file (store, document_uuid, fields, '')
end