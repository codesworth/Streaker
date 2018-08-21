//
//  DatabaseService.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/24/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CW-Predef_Header.h"


@import Firebase;
@import FirebaseDatabase;
@import CoreLocation;

@class ScoreData;

typedef NSUInteger(^ExecuteOnComplete)(void);
typedef void(^Completed)(id _Nullable collection, NSError* _Nullable error);

typedef void (^ExecuteAfterFinish)(void);
@interface DatabaseService : NSObject

//@property (strong,nonatomic) FIRDatabaseReference* mainReference;
@property (strong,nonatomic) FIRDatabaseReference* _Nonnull userReference;

-(void)saveFIRGamer:(NSString*_Nonnull)uid userInfo:(NSDictionary*_Nonnull)info;
-(FIRDatabaseReference*_Nonnull)mainReference;
-(FIRDatabaseReference*_Nonnull)userReference;
-(FIRDatabaseReference*_Nonnull)challengeRef;
-(FIRDatabaseReference*_Nonnull)scoreRef;
-(FIRDatabaseReference*_Nonnull)messageRef;
-(FIRStorageReference*_Nonnull)storageRef;
-(FIRDatabaseReference*_Nonnull)notificationRef;
-(FIRDatabaseReference* _Nonnull)reportRef;
-(FIRDatabaseReference* _Nonnull)tokenRef;
+(id _Nonnull )main;
+(NSString* _Nullable)configureUsername:(Challenge* _Nonnull)challenge id:(NSString* _Nonnull)uid;

-(void)updateUserLocation:(nonnull NSDictionary*)coordinates e:(nullable ExecuteAfterFinish)done;
-(void)fb_saveLoosingStreak:(nonnull ScoreData*)manager execute:(ExecuteAfterFinish _Nullable)onCompletion;
-(void)awakeFromFBDatabase:( NSString* _Nonnull )uid exec:(ExecuteAfterFinish _Nullable)onComplete;
-(void)fb_initScoreData:(NSString* _Nonnull)userUID exec:(ExecuteAfterFinish _Nullable)onComplete;
-(void)fb_fetch_Listed;
-(void)fb_saveUnsavedGamedata:(ExecuteAfterFinish _Nullable)onCompletion;
//-(void)saveGameDataToFirebase:(ScoreData* _Nullable)manager execute:(ExecuteAfterFinish _Nullable)onCompletion;
-(void)fb_SaveRegGameScore:(ScoreData* _Nonnull)manager execute:(ExecuteAfterFinish _Nullable)onCompletion;
-(void)fb_Add_User:(NSString* _Nonnull)uid;
-(void)fb_saveClassicGameScore:(ScoreData* _Nonnull)manager execute:(ExecuteAfterFinish _Nullable)onCompletion;
-(void)fb_saveHighStreak:(ScoreData* _Nonnull)manager execute:(ExecuteAfterFinish _Nullable)onCompletion;
//-(void)fb_saveAllTimeGameCount:(ScoreData* _Nonnull)manager execute:(ExecuteAfterFinish _Nullable)onCompletion;
-(void)fb_saveAllTimeStats:(ScoreData * _Nonnull)manager execute:(ExecuteAfterFinish _Nullable)onCompletion;
-(void)deleteUserAccount:(NSString* _Nonnull)uid;
-(BOOL)check_fb_connection;

-(void)fb_fetchScoreData:(NSMutableArray* _Nonnull)gamers exec:(ExecuteAfterFinish _Nullable)onComplete;
-(void)fb_fetch_ScoreData:(Gamer* _Nonnull)user exec:(ExecuteAfterFinish _Nullable)onComplete;
-(void)fb_fetchListed:(NSMutableArray* _Nonnull)gamers exec:(ExecuteAfterFinish _Nullable)onComplete;
//MARK:- CHALLENGE METHODS
-(void)fb_Request_setChallenge:(NSString* _Nonnull)senderUID receipient:(NSString* _Nonnull)uid andDate:(NSString* _Nonnull)date withChID:(NSString* _Nonnull)challengeID and:(NSDictionary* _Nonnull)usernames;
-(void)fb_getCHRequests:(Completed _Nullable)didFinish;
-(void)fb_RejectCH_Request:(Challenge* _Nullable)challenge;
-(void)fb_AcceptCH_Request:(Challenge* _Nullable)challenge didFinish:(ExecuteAfterFinish _Nullable)oncomplete;
-(void)fb_fetch_ActiveCH:(Completed _Nullable)onComplete;
-(void)fb_getPendingRequests:(Completed _Nullable)didFinish;
-(void)NotifiedGameFinished:(Challenge* _Nonnull)challenge;
//
//-(void)fb_fetchSelf:(NSMutableArray* _Nonnull)selff exec:(nonnull ExecuteAfterFinish)finished;
-(void)fb_fetchUserDetails:(nonnull NSString*)uid intoArray:(nonnull NSMutableArray*)array exec:(nullable ExecuteAfterFinish)onComplete;

-(void)fb_fetchScorelessUserDetails:(nonnull NSString*)uid intoArray:(nonnull NSMutableArray*)array exec:(nullable ExecuteAfterFinish)onComplete;

-(void)removePending:(nonnull Challenge*)challenge exec:(nullable ExecuteAfterFinish)finished;
-(void)removeFinished:(nonnull Challenge*)challenge exec:(nullable ExecuteAfterFinish)finished;

-(void)removeRequest:(nonnull Challenge *)challenge exec:(nullable ExecuteAfterFinish)finished;
//ScoreUpdate
-(nonnull NSString*)opponent:(Challenge* _Nonnull)challenge;
-(void)fb_observeGameWinner:(nonnull Challenge*)challenge;
-(void)fb_InstanceOfOT:(NSUInteger)score fromChallenge:(nonnull Challenge*)challenge withNo:(nonnull NSString*)gameNumber;
-(void)returnInstanceOfOT:(nonnull Challenge*)challenge with:(NSMutableDictionary* _Nonnull)dictionary exec:(ExecuteAfterFinish _Nullable)oncomplete;
-(void)fb_updateScore:(NSDictionary* _Nonnull)dictionary fromChallenge:(Challenge* _Nonnull)challenge withNo:(nonnull NSString*)gameNumber didFinish:(nullable ExecuteAfterFinish)oncomplete;
-(void)fb_writeOfOT:(nonnull Challenge*)challenge andNo:(NSString* _Nonnull)gameNo;
-(void)fb_fetchGameWins:(nonnull Challenge*)challenge intoArray:(nonnull NSMutableArray*)array exec:(nonnull ExecuteAfterFinish)onComplete;
-(void)availableActiveCH:(NSMutableArray* _Nonnull)activeArray didFinish:(ExecuteAfterFinish _Nullable)onComplete;
-(void)forfeitGame:(Challenge*_Nonnull)challenge e:(ExecuteAfterFinish _Nullable )finished;
-(void)fetchallUsers:(nonnull NSMutableArray *)allUsers queryLimit:(NSUInteger)limit exec:(nullable ExecuteAfterFinish)finished;

//-(void)fetchNearbyUsers:(NSMutableArray* _Nonnull)nearbyUsers exec:(ExecuteAfterFinish _Nullable)finished;

-(void)sendMessage:(NSDictionary* _Nonnull)messageDict withID:(NSString* _Nonnull)challengeID e:(nullable ExecuteAfterFinish)exec;

#pragma mark - Queries

-(void)queryForChatMessages:(Challenge* _Nonnull)challenge e:(ExecuteAfterFinish _Nullable)exec;
-(void)readMessageReceipt:(NSString* _Nonnull)challengeKey h:(FIRDatabaseHandle)handle e:(ExecuteAfterFinish _Nullable)exec;
//-(void)getKeys:(ExecuteAfterFinish _Nullable)exec;
-(void)observeRequestAccepted:(ExecuteAfterFinish _Nullable)exec;
-(void)observeRequestSent:(ExecuteAfterFinish _Nullable)exec;
-(void)observeGameEnded:(NSString* _Nonnull)challengeKey count:(NSUInteger)count e:(ExecuteAfterFinish _Nullable)exec;
-(void)notifyNextPlay:(Challenge* _Nonnull)challenge;
-(void)notifyMessageReceived:(Challenge* _Nonnull)challenge h:(FIRDatabaseHandle)handle e:(ExecuteAfterFinish _Nullable)exec;

-(void)fb_fetchTop_ScoreData:(NSMutableArray* _Nullable)gamers child:(NSString* _Nonnull)child endValue:(NSUInteger)value exec:(ExecuteAfterFinish _Nullable)onComplete;
-(void)LogUserReport:(Gamer* _Nonnull)voilater with:(NSString* _Nonnull)details on:(ExecuteAfterFinish _Nullable)sent;

-(void)searchUserwith:(NSString*_Nullable)name queryLimited:(NSUInteger)limit into:(NSArray* _Nonnull)array on:(ExecuteAfterFinish _Nullable)complete;
+(void)removeAllobservers:(FIRDatabaseReference*_Nullable)ref;

-(void)fetchNearbyUsers:(NSString*_Nullable)locality queryLimited:(NSUInteger)limit into:(NSArray*_Nonnull)array onFinish:(ExecuteAfterFinish _Nullable )completed;
-(void)postToken:(NSString* _Nonnull)token;
@end
