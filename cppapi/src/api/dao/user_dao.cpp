#include "user_dao.h"
#include "user_dto.h"

namespace gardendb {
    namespace sql {
        using UserDto = gardendb::dto::UserDto;                
        std::vector<UserDto> get_all() {
            std::vector<UserDto> users;
            return users;
        }
        bool UserDao::save(const UserDto &location) {
            return false;
        }
        std::unique_ptr<UserDto> UserDao::fromApiKey(const std::string& apikey){
            return std::make_unique<UserDto>(0,"guest1","guest1","");
        }
        std::unique_ptr<UserDto> UserDao::fromName(const std::string& name) {
            return std::make_unique<UserDto>(0,"guest2","guest2","");
        }
    }
}