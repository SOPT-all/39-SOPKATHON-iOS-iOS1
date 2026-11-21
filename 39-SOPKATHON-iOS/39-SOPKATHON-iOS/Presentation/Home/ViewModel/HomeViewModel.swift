//
//  HomeViewModel.swift
//  39-SOPKATHON-iOS
//
//  Created by 전시언 on 11/22/26.
//

import Foundation

@Observable
final class HomeViewModel {

    /// 내 이름(성 포함). 프로필에는 뒤 두 글자를 표시함.
    private(set) var myName = ""
    private(set) var schoolName = ""
    private(set) var members: [HomeMember] = []
    private(set) var isLoading = false
    private(set) var errorMessage = ""
    var isShowingError = false

    func fetchHome() async {
        guard !isLoading else { return }
        guard let request = HomeRequest.demo else {
            showError("Config.xcconfig의 MEMBER_ID·GRADE·CLASS_NUMBER 값을 확인해 주세요.")
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response: HomeResponseDTO = try await BaseService.shared.request(
                endPoint: .home(
                    memberID: request.memberID,
                    grade: request.grade,
                    classNumber: request.classNumber
                )
            )
            apply(response)
        } catch is CancellationError {
            // 화면을 벗어나 요청이 취소된 경우라 알리지 않음.
        } catch {
            showError((error as? LocalizedError)?.errorDescription ?? "홈 정보를 불러오지 못했어요.")
        }
    }

}

private extension HomeViewModel {

    func apply(_ response: HomeResponseDTO) {
        myName = response.me.displayName
        schoolName = response.school.name

        // 명세에 활동 상태가 없어 시연 팀 구성(나 + 첫 번째 팀원)만 활동 중으로 표시함.
        let teammateID = response.members.first { !$0.isMe }?.memberID
        members = response.members.map { member in
            HomeMember(
                id: member.memberID,
                name: member.displayName,
                isActive: member.isMe || member.memberID == teammateID
            )
        }
    }

    func showError(_ message: String) {
        errorMessage = message
        isShowingError = true
    }

}

/// 홈 조회에 필요한 값.
private struct HomeRequest {

    let memberID: Int
    let grade: Int
    let classNumber: Int

    // TODO: 온보딩 연동 후 사용자가 입력한 값으로 교체 필요. 지금은 Config.xcconfig 시연값을 읽음.
    static var demo: HomeRequest? {
        guard
            let memberID = infoInt(for: "MEMBER_ID"),
            let grade = infoInt(for: "GRADE"),
            let classNumber = infoInt(for: "CLASS_NUMBER")
        else {
            return nil
        }
        return HomeRequest(memberID: memberID, grade: grade, classNumber: classNumber)
    }

    private static func infoInt(for key: String) -> Int? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            return nil
        }
        return Int(value)
    }

}
