#pragma once

#ifndef Verify_hpp
#define Verify_hpp

#include <memory>

class VERIFY {
    friend std::default_delete<VERIFY>;

   public:
    VERIFY(const VERIFY&) = delete;
    VERIFY& operator=(const VERIFY&) = delete;
    static int Register(int armyID, int privilege);
    static VERIFY& Singleton();

    int GetArmyID() const;

   private:
    VERIFY(int armyID, int privilege);
    ~VERIFY() = default;

    inline static std::unique_ptr<VERIFY> singleton_;

    int _armyID, _privilege;
};

#endif  // Verify_hpp
