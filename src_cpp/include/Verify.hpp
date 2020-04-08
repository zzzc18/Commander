#pragma once

#ifndef Verify_hpp
#define Verify_hpp

class VERIFY {
   public:
    VERIFY(const VERIFY&) = delete;
    VERIFY& operator=(const VERIFY&) = delete;
    static int Register(int armyID, int privilege);
    static VERIFY& Singleton();

    int GetArmyID() const;

   private:
    VERIFY(int armyID, int privilege);
    ~VERIFY() = default;
    inline static VERIFY* singletonPtr_;
    struct DELETER {
        ~DELETER();
    };
    static DELETER deleter_;

    int _armyID, _privilege;
};

#endif  // Verify_hpp
