/**
 * @file Verify.hpp
 *
 * @brief @c Verify 模块非 API 部分的声明
 */

#pragma once

#ifndef Verify_hpp
#define Verify_hpp

/**
 * @brief 描述一个军队的注册信息
 *
 * @note 这是一个单例类，因为每个军队只能注册一次
 */
class VERIFY final {
   public:
    VERIFY(const VERIFY&) = delete;
    VERIFY& operator=(const VERIFY&) = delete;
    //注册编号为 armyID，权限为 privilege 的军队，返回结果描述注册成功与否
    static int Register(int armyID, int privilege);
    static VERIFY& Singleton();  //获得单例实例

    int GetArmyID() const;  //该军队注册的编号

   private:
    //创建编号为 armyID，权限为 privilege 的军队的注册信息
    VERIFY(int armyID, int privilege);
    ~VERIFY() = default;
    inline static VERIFY* singletonPtr_;  //指向单例的指针（该类不能默认构造）
    struct DELETER {  //删除 VERIFY 单例指针的辅助类
        ~DELETER();
    };
    static DELETER deleter_;

    int _armyID, _privilege;  //军队编号、权限
};

#endif  // Verify_hpp
