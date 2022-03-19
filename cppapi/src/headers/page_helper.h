// Copyright 2022 Michael Neilson
// Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md
// Except portions incidated
#pragma once
#include <crow/mustache.h>

#include <sstream>
#include <fstream>

std::string adjust_filename(std::string in){
// totally yanked from the crowcpp default loader
    std::string path = crow::mustache::detail::get_template_base_directory_ref();
    if (!(path.back() == '/' || path.back() == '\\'))
        path += '/';
    path += in;
    return path;
}

/**
 * Load a template that may have another mustache template loaded in 
 */
std::string nested_loader(const std::string &filename){
    const std::string include_token = "!include ";
    std::string file_data;
    std::stringstream ss;

    std::string path = adjust_filename(filename); // start the yanked code
    std::ifstream inf(path);
    if (!inf)
    {
        CROW_LOG_WARNING << "Template \"" << filename << "\" not found.";
        return {};
    }    
    // end original
    ss << inf.rdbuf();
    file_data = ss.str();
    //std::cout << file_data << std::endl;
    size_t idx = std::string::npos;
    while( (idx = file_data.find(include_token)) != std::string::npos) {
        auto end_of_line = file_data.find_first_of('!', idx+1);
        auto filename_length = (end_of_line-idx)-include_token.size();
        std::string nested_name = file_data.substr(idx+include_token.size(), filename_length);
        std::fstream nextf(adjust_filename(nested_name));
        if(!nextf) {
            CROW_LOG_WARNING << "Nested Template \"" << nested_name << "\" not found";
            file_data.replace(idx,end_of_line+1,"");
            continue;
        }
        std::stringstream nestedstream;
        nestedstream << nextf.rdbuf();
        file_data.replace(idx,end_of_line+1, nestedstream.str());
        //std::cout << file_data << std::endl;
    }
    
    
    return file_data;
}